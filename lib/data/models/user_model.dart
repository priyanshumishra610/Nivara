import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;
  
  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [id, email, name, avatarUrl, createdAt];
}

