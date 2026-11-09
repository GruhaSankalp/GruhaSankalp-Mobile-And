import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<bool> sendOtp(String phoneNumber);
  Future<UserEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required UserPersona persona,
  });
  Future<UserEntity?> getCurrentUser();
  Future<void> signOut();
  Future<void> updatePersona(UserPersona persona);
  Future<bool> hasSeenOnboarding();
  Future<void> setHasSeenOnboarding();
}

