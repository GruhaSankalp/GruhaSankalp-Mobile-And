import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;
  SendOtpUseCase(this._repository);

  Future<bool> execute(String phoneNumber) {
    return _repository.sendOtp(phoneNumber);
  }
}

class VerifyOtpUseCase {
  final AuthRepository _repository;
  VerifyOtpUseCase(this._repository);

  Future<UserEntity> execute({
    required String phoneNumber,
    required String otp,
    required UserPersona persona,
  }) {
    return _repository.verifyOtp(
      phoneNumber: phoneNumber,
      otp: otp,
      persona: persona,
    );
  }
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  Future<UserEntity?> execute() {
    return _repository.getCurrentUser();
  }
}

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<void> execute() {
    return _repository.signOut();
  }
}

