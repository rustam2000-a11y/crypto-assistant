abstract class LoginEvent {
  const LoginEvent();
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;
}

class SignInWithEmailPressed extends LoginEvent {
  const SignInWithEmailPressed();
}

class SignInWithGooglePressed extends LoginEvent {
  const SignInWithGooglePressed();
}

class SignInWithApplePressed extends LoginEvent {
  const SignInWithApplePressed();
}

class LoginLoadingEvent extends LoginEvent {
  const LoginLoadingEvent({required this.isLoading});

  final bool isLoading;
}

class LoginErrorEvent extends LoginEvent {
  const LoginErrorEvent({required this.error});

  final bool error;
}
