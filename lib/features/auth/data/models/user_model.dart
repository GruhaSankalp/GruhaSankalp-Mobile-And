import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.phoneNumber,
    super.fullName,
    super.email,
    required super.persona,
    super.isVerified,
    super.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: json['phoneNumber'] ?? json['phone'] ?? '',
      fullName: json['fullName'] ?? json['name'] ?? 'Sovereign Investor',
      email: json['email'],
      persona: _parsePersona(json['persona']?.toString()),
      isVerified: json['isVerified'] as bool? ?? true,
      accessToken: json['accessToken'] ?? json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'email': email,
      'persona': persona.name,
      'isVerified': isVerified,
      'accessToken': accessToken,
    };
  }

  static UserPersona _parsePersona(String? val) {
    switch (val?.toLowerCase()) {
      case 'tenant':
        return UserPersona.tenant;
      case 'owner':
        return UserPersona.owner;
      case 'builder':
        return UserPersona.builder;
      case 'agent':
        return UserPersona.agent;
      case 'buyer':
      default:
        return UserPersona.buyer;
    }
  }
}

