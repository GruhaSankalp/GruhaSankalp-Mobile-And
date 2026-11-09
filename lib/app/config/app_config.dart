import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/config/env_config.dart';

class AppConfig {
  static Future<void> initialize({Environment env = Environment.dev}) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Environment (dev, staging, prod)
    EnvConfig.initialize(env);

    // Lock to portrait orientation for ergonomic thumb-zone usage
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Transparent status bar for edge-to-edge luxury design
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}

