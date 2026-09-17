import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/auth_exceptions.dart';
import '../../../generated/l10n.dart';
import '../../data/repository/auth_repository.dart';
import 'registration_effect.dart';
import 'registration_event.dart';
import 'registration_state.dart';

@injectable
class RegistrationBloc
    extends
        EffectBloc<RegistrationEvent, RegistrationState, RegistrationEffect> {
  RegistrationBloc({required AuthRepositoryI repository})
    : _repository = repository,
      super(const RegistrationState()) {
    on<RegisterNameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
    on<RegisterEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<RegisterPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<RegistrationLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: event.isLoading));
    });
    on<RegistrationErrorEvent>((event, emit) {
      emit(state.copyWith(error: event.error));
    });
    on<RegisterWithEmailPressed>((event, emit) {
      _registerWithEmail();
    });
    on<RegisterWithGooglePressed>((event, emit) {
      _registerWithGoogle();
    });
    on<RegisterWithApplePressed>((event, emit) {
      _registerWithApple();
    });
  }

  static const _minPasswordLength = 6;

  final AuthRepositoryI _repository;

  Future<void> _registerWithEmail() async {
    if (state.password.length < _minPasswordLength) {
      add(const RegistrationErrorEvent(error: true));
      return;
    }
    add(const RegistrationErrorEvent(error: false));
    add(const RegistrationLoadingEvent(isLoading: true));
    try {
      final user = await _repository.registerWithEmail(
        email: state.email,
        password: state.password,
        name: state.name,
      );
      add(const RegistrationLoadingEvent(isLoading: false));
      if (user != null) emitEffect(RegistrationSucceeded(user));
    } catch (e) {
      add(const RegistrationLoadingEvent(isLoading: false));
      emitEffect(RegistrationFailed(_describeError(e)));
    }
  }

  Future<void> _registerWithGoogle() async {
    add(const RegistrationLoadingEvent(isLoading: true));
    try {
      final user = await _repository.signInWithGoogle();
      add(const RegistrationLoadingEvent(isLoading: false));
      if (user != null) emitEffect(RegistrationSucceeded(user));
    } catch (e) {
      add(const RegistrationLoadingEvent(isLoading: false));
      emitEffect(RegistrationFailed(_describeError(e)));
    }
  }

  Future<void> _registerWithApple() async {
    add(const RegistrationLoadingEvent(isLoading: true));
    try {
      final user = await _repository.signInWithApple();
      add(const RegistrationLoadingEvent(isLoading: false));
      if (user != null) emitEffect(RegistrationSucceeded(user));
    } catch (e) {
      add(const RegistrationLoadingEvent(isLoading: false));
      emitEffect(RegistrationFailed(_describeError(e)));
    }
  }

  String _describeError(Object error) {
    return switch (error) {
      WeakPasswordException() => S.current.weakPassword,
      EmailAlreadyInUseException() => S.current.emailAlreadyInUse,//
      InvalidEmailException() => S.current.invalidEmail,
      _ => S.current.failedToSignUp,
    };
  }
}
