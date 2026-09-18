import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/auth_error_type.dart';
import '../../../core/errors/auth_exceptions.dart';
import '../../data/repository/auth_repository.dart';
import 'login_effect.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginBloc extends EffectBloc<LoginEvent, LoginState, LoginEffect> {
  LoginBloc({required AuthRepositoryI repository})
    : _repository = repository,
      super(const LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<LoginLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: event.isLoading));
    });
    on<LoginErrorEvent>((event, emit) {
      emit(state.copyWith(error: event.error));
    });
    on<SignInWithEmailPressed>((event, emit) {
      _signInWithEmail();
    });
    on<SignInWithGooglePressed>((event, emit) {
      _signInWithGoogle();
    });
    on<SignInWithApplePressed>((event, emit) {
      _signInWithApple();
    });
  }

  static const _minPasswordLength = 6;

  final AuthRepositoryI _repository;

  Future<void> _signInWithEmail() async {
    if (state.password.length < _minPasswordLength) {
      add(const LoginErrorEvent(error: true));
      return;
    }
    add(const LoginErrorEvent(error: false));
    add(const LoginLoadingEvent(isLoading: true));
    try {
      final user = await _repository.signInWithEmail(
        email: state.email,
        password: state.password,
      );
      add(const LoginLoadingEvent(isLoading: false));
      if (user != null) emitEffect(LoginSucceeded(user));
    } on Exception catch (e) {
      add(const LoginLoadingEvent(isLoading: false));
      emitEffect(LoginFailed(_mapError(e)));
    }
  }

  Future<void> _signInWithGoogle() async {
    add(const LoginLoadingEvent(isLoading: true));
    try {
      final user = await _repository.signInWithGoogle();
      add(const LoginLoadingEvent(isLoading: false));
      if (user != null) emitEffect(LoginSucceeded(user));
    } on Exception catch (e) {
      add(const LoginLoadingEvent(isLoading: false));
      emitEffect(LoginFailed(_mapError(e)));
    }
  }

  Future<void> _signInWithApple() async {
    add(const LoginLoadingEvent(isLoading: true));
    try {
      final user = await _repository.signInWithApple();
      add(const LoginLoadingEvent(isLoading: false));
      if (user != null) emitEffect(LoginSucceeded(user));
    } on Exception catch (e) {
      add(const LoginLoadingEvent(isLoading: false));
      emitEffect(LoginFailed(_mapError(e)));
    }
  }

  AuthErrorType _mapError(Object error) {
    return switch (error) {
      InvalidEmailException() => AuthErrorType.invalidEmail,
      _ => AuthErrorType.unknown,
    };
  }
}
