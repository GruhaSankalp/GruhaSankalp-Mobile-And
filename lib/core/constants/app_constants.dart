abstract class AppConstants {
  static const String appName = 'GruhaSankalp';
  static const String appTagline = 'Sovereign Real Estate & Legal Clearinghouse';
  
  // Storage Keys
  static const String keyAccessToken = 'gs_access_token';
  static const String keyRefreshToken = 'gs_refresh_token';
  static const String keyUserData = 'gs_user_data';
  static const String keyUserPersona = 'gs_user_persona';
  static const String keyBiometricEnabled = 'gs_biometric_enabled';
  static const String keyHasSeenOnboarding = 'gs_has_seen_onboarding';

  // API Headers
  static const String headerAuthorization = 'Authorization';
  static const String headerBearerPrefix = 'Bearer ';
  static const String headerApiKey = 'X-API-Key';

  // Default Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 20);

  // Formatting Formats
  static const String currencySymbol = '₹';
  static const String gatePassPrefix = 'GS-';
}

