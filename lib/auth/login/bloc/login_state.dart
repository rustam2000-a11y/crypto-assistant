import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error = false,
  });

  final String email;
  final String password;
  final bool isLoading;
  final bool error;
  LoginState copyWith({String? email, String? password, bool? isLoading,bool?error}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [email, password, isLoading,error];
}
