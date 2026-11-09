import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/config/app_config.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/config/env_config.dart';

void main() async {
  await AppConfig.initialize(env: Environment.dev);
  runApp(
    const ProviderScope(
      child: GruhaSankalpApp(),
    ),
  );
}

class GruhaSankalpApp extends ConsumerWidget {
  const GruhaSankalpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'GruhaSankalp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
