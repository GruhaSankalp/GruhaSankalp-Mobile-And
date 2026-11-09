import 'dart:convert';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService storageService,
  })  : _remoteDataSource = remoteDataSource,
        _storageService = storageService;

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    return await _remoteDataSource.sendOtp(phoneNumber);
  }

  @override
  Future<UserEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required UserPersona persona,
  }) async {
    final userModel = await _remoteDataSource.verifyOtp(
      phoneNumber: phoneNumber,
      otp: otp,
      persona: persona,
    );

    if (userModel.accessToken != null) {
      await _storageService.saveAccessToken(userModel.accessToken!);
    }
    await _storageService.saveUserPersona(persona.name);
    return userModel;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await _storageService.getAccessToken();
    if (token == null) return null;

    final personaStr = await _storageService.getUserPersona();
    final persona = personaStr == 'tenant'
        ? UserPersona.tenant
        : personaStr == 'owner'
            ? UserPersona.owner
            : personaStr == 'builder'
                ? UserPersona.builder
                : UserPersona.buyer;

    return UserEntity(
      id: 'usr_sov_9918',
      phoneNumber: '+91 98765 43210',
      fullName: 'Sovereign Investor',
      persona: persona,
      isVerified: true,
      accessToken: token,
    );
  }

  @override
  Future<void> signOut() async {
    await _storageService.clearAuthTokens();
  }

  @override
  Future<void> updatePersona(UserPersona persona) async {
    await _storageService.saveUserPersona(persona.name);
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    return await _storageService.hasSeenOnboarding();
  }

  @override
  Future<void> setHasSeenOnboarding() async {
    await _storageService.setHasSeenOnboarding(true);
  }
}

