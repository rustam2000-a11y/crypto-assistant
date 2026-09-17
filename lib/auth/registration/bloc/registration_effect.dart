import 'package:equatable/equatable.dart';

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
  const RegistrationFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
