import 'package:equatable/equatable.dart';

import '../../../core/models/user_model.dart';

abstract class LoginEffect extends Equatable {
  const LoginEffect();

  @override
  List<Object?> get props => [];
}

class LoginSucceeded extends LoginEffect {
  const LoginSucceeded(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

class LoginFailed extends LoginEffect {
  const LoginFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

