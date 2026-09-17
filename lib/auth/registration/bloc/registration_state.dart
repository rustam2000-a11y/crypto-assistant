import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  const RegistrationState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error = false,
  });

  final String name;
  final String email;
  final String password;
  final bool isLoading;
  final bool error;

  RegistrationState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isLoading,
    bool? error,
  }) {
    return RegistrationState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [name, email, password, isLoading, error];
}
