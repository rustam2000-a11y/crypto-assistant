import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/errors/auth_exceptions.dart';
import '../../../core/models/user_model.dart';

const _emailAlreadyInUse = 'email-already-in-use';
const _invalidEmail = 'invalid-email';
const _weakPassword = 'weak-password';

@Injectable(as: AuthApiI)
class AuthApi extends AuthApiI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static const _googleServerClientId =
      '449327116621-9hh2e89auvmhkafbn24lt9sjcto69n6r.apps.googleusercontent.com';

  // Ignored on Android (read from google-services.json there); required on
  // iOS/macOS/web since we don't set GIDClientID in Info.plist.
  static const _googleIosClientId =
      '449327116621-m85002n56m497sqev7qn8rmk16kfs5dc.apps.googleusercontent.com';

  bool _googleSignInInitialized = false;


  Never _throwEmailAuthError(FirebaseAuthException e) {
    if (e.code == _invalidEmail) throw InvalidEmailException();
    if (e.code == _weakPassword) throw WeakPasswordException();
    if (e.code == _emailAlreadyInUse) throw EmailAlreadyInUseException();
    throw e;
  }

  @override
  Stream<bool> authStateChanges() =>
      _auth.authStateChanges().map((user) => user != null);

  @override
  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      coinIds: const [],
    );
  }

  @override
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    UserCredential userCred;
    try {
      userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _throwEmailAuthError(e);
    }
    final user = userCred.user;
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      coinIds: const [],
    );
  }

  @override
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    UserCredential userCred;
    try {
      userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _throwEmailAuthError(e);
    }
    final user = userCred.user;
    if (user == null) return null;

    await user.updateDisplayName(name);
    await user.reload();
    return _saveUserProfile(user, name: name);
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }

    final credential = GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;
    if (user == null) return null;

    return _saveUserProfile(
      user,
      name: account.displayName,
      avatarUrl: account.photoUrl,
    );
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await _googleSignIn.initialize(
      clientId: _googleIosClientId,
      serverClientId: _googleServerClientId,
    );
    _googleSignInInitialized = true;
  }

  @override
  Future<UserModel?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCred = await _auth.signInWithCredential(oauthCredential);
    final user = userCred.user;
    if (user == null) return null;

    final name = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].whereType<String>().join(' ');
    return _saveUserProfile(user, name: name.isNotEmpty ? name : null);
  }

  Future<UserModel> _saveUserProfile(
    User user, {
    String? name,
    String? avatarUrl,
  }) async {
    final resolvedName = name?.isNotEmpty == true
        ? name!
        : (user.displayName ?? '');
    final resolvedEmail = user.email ?? '';

    await _firestore.collection('user').doc(user.uid).set({
      'uid': user.uid,
      'email': resolvedEmail,
      'name': resolvedName,
      'avatarUrl': avatarUrl,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return UserModel(
      id: user.uid,
      name: resolvedName,
      email: resolvedEmail,
      coinIds: const [],
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() async {
    if (_googleSignInInitialized) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('user').doc(uid).get();
    final data = doc.data();
    if (data == null) return null;

    return UserModel.fromDocument(data);
  }

  @override
  Stream<UserModel?> watchCurrentUserProfile() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);

    return _firestore.collection('user').doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return UserModel.fromDocument(data);
    });
  }
}

abstract class AuthApiI {
  Stream<bool> authStateChanges();

  UserModel? get currentUser;

  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel?> signInWithGoogle();

  Future<UserModel?> signInWithApple();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> logout();

  Future<UserModel?> getCurrentUserProfile();

  Stream<UserModel?> watchCurrentUserProfile();
}
