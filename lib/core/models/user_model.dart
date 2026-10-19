import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.coinIds,
  });

  factory UserModel.fromDocument(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      coinIds: (json['coinIds'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  final String id;
  final String name;
  final String email;
  final List<String> coinIds;

  @override
  List<Object?> get props => [id, name, email, coinIds];

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    List<String>? coinIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      coinIds: coinIds ?? this.coinIds,
    );
  }

  Map<String, dynamic> toDocument() {
    return {'uid': id, 'name': name, 'email': email, 'coinIds': coinIds};
  }
}
