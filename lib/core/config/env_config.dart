enum Environment { dev, staging, prod }

class EnvConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String apiVersion;
  final bool enableLogging;
  final bool fallbackToLocalData;

  const EnvConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.apiVersion,
    required this.enableLogging,
    this.fallbackToLocalData = true,
  });

  static EnvConfig dev = const EnvConfig(
    environment: Environment.dev,
    apiBaseUrl: 'http://10.0.2.2:5000/api', // Android Emulator localhost bridge for ASP.NET Core
    apiVersion: 'v1',
    enableLogging: true,
    fallbackToLocalData: true,
  );

  static EnvConfig staging = const EnvConfig(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.gruhasankalp.com/api',
    apiVersion: 'v1',
    enableLogging: true,
    fallbackToLocalData: false,
  );

  static EnvConfig prod = const EnvConfig(
    environment: Environment.prod,
    apiBaseUrl: 'https://api.gruhasankalp.com/api',
    apiVersion: 'v1',
    enableLogging: false,
    fallbackToLocalData: false,
  );

  static EnvConfig current = dev;

  static void initialize(Environment env) {
    switch (env) {
      case Environment.dev:
        current = dev;
        break;
      case Environment.staging:
        current = staging;
        break;
      case Environment.prod:
        current = prod;
        break;
    }
  }
}

