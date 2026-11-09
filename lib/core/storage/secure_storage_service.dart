import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.keyRefreshToken);
  }

  Future<void> saveUserPersona(String persona) async {
    await _storage.write(key: AppConstants.keyUserPersona, value: persona);
  }

  Future<String?> getUserPersona() async {
    return await _storage.read(key: AppConstants.keyUserPersona);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: AppConstants.keyBiometricEnabled,
      value: enabled.toString(),
    );
  }

  Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: AppConstants.keyBiometricEnabled);
    return val == 'true';
  }

  Future<void> setHasSeenOnboarding(bool seen) async {
    await _storage.write(
      key: AppConstants.keyHasSeenOnboarding,
      value: seen.toString(),
    );
  }

  Future<bool> hasSeenOnboarding() async {
    final val = await _storage.read(key: AppConstants.keyHasSeenOnboarding);
    return val == 'true';
  }

  Future<void> clearAuthTokens() async {
    await _storage.delete(key: AppConstants.keyAccessToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

