import 'package:injectable/injectable.dart';

import '../../../core/models/user_model.dart';
import '../api/auth_api.dart';

@LazySingleton(as: AuthRepositoryI)
class AuthRepository extends AuthRepositoryI {
  AuthRepository({required AuthApiI api}) : _api = api;

  final AuthApiI _api;

  @override
  Stream<bool> authStateChanges() => _api.authStateChanges();

  @override
  UserModel? get currentUser => _api.currentUser;

  @override
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _api.signInWithEmail(email: email, password: password);
  }

  @override
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) {
    return _api.registerWithEmail(email: email, password: password, name: name);
  }

  @override
  Future<UserModel?> signInWithGoogle() => _api.signInWithGoogle();

  @override
  Future<UserModel?> signInWithApple() => _api.signInWithApple();

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _api.sendPasswordResetEmail(email);
  }

  @override
  Future<void> logout() => _api.logout();

  @override
  Future<UserModel?> getCurrentUserProfile() => _api.getCurrentUserProfile();

  @override
  Stream<UserModel?> watchCurrentUserProfile() =>
      _api.watchCurrentUserProfile();
}

abstract class AuthRepositoryI {
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
