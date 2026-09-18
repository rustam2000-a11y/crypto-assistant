import 'package:equatable/equatable.dart';

import '../../../core/errors/auth_error_type.dart';
import '../../../core/models/user_model.dart';

abstract class RegistrationEffect extends Equatable {
  const RegistrationEffect();

  @override
  List<Object?> get props => [];
}

class RegistrationSucceeded extends RegistrationEffect {
  const RegistrationSucceeded(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

class RegistrationFailed extends RegistrationEffect {
  const RegistrationFailed(this.errorType);

  final AuthErrorType errorType;

  @override
  List<Object?> get props => [errorType];
}
