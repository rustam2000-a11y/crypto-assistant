abstract class RegistrationEvent {
  const RegistrationEvent();
}

class RegisterNameChanged extends RegistrationEvent {
  const RegisterNameChanged(this.name);

  final String name;
}

class RegisterEmailChanged extends RegistrationEvent {
  const RegisterEmailChanged(this.email);

  final String email;
}

class RegisterPasswordChanged extends RegistrationEvent {
  const RegisterPasswordChanged(this.password);

  final String password;
}

class RegisterWithEmailPressed extends RegistrationEvent {
  const RegisterWithEmailPressed();
}

class RegisterWithGooglePressed extends RegistrationEvent {
  const RegisterWithGooglePressed();
}

class RegisterWithApplePressed extends RegistrationEvent {
  const RegisterWithApplePressed();
}

class RegistrationLoadingEvent extends RegistrationEvent {
  const RegistrationLoadingEvent({required this.isLoading});

  final bool isLoading;
}

class RegistrationErrorEvent extends RegistrationEvent {
  const RegistrationErrorEvent({required this.error});

  final bool error;
}
