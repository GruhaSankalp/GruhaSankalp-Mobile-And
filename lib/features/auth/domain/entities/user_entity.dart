import 'package:equatable/equatable.dart';

enum UserPersona { buyer, tenant, owner, builder, agent }

class UserEntity extends Equatable {
  final String id;
  final String phoneNumber;
  final String? fullName;
  final String? email;
  final UserPersona persona;
  final bool isVerified;
  final String? accessToken;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    this.fullName,
    this.email,
    required this.persona,
    this.isVerified = false,
    this.accessToken,
  });

  @override
  List<Object?> get props => [id, phoneNumber, fullName, email, persona, isVerified, accessToken];
}

