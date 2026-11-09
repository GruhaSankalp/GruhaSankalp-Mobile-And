import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/persona_selection_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/gatepass/presentation/screens/book_site_visit_screen.dart';
import '../../features/gatepass/presentation/screens/gatepass_screen.dart';
import '../../features/gruha_ai/presentation/screens/gruha_ai_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/properties/presentation/screens/home_feed_screen.dart';
import '../../features/properties/presentation/screens/property_comparison_screen.dart';
import '../../features/properties/presentation/screens/property_detail_screen.dart';
import '../../features/tools/presentation/screens/emi_calculator_screen.dart';
import '../../shared/widgets/main_scaffold_nav.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Persona Selector
      GoRoute(
        path: '/persona-selector',
        builder: (context, state) => const PersonaSelectionScreen(),
      ),

      // Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Property Details (Full-screen route)
      GoRoute(
        path: '/properties/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PropertyDetailScreen(propertyId: id);
        },
      ),

      // Book Site Visit (Full-screen route)
      GoRoute(
        path: '/book-visit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return BookSiteVisitScreen(propertyId: id);
        },
      ),

      // Comparison Matrix
      GoRoute(
        path: '/compare',
        builder: (context, state) => const PropertyComparisonScreen(),
      ),

      // Main Navigation Shell (Stateful tabs)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffoldNav(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Discover / Home Feed
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeFeedScreen(),
              ),
            ],
          ),

          // Branch 1: GatePass Ticket & Scanner
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/gatepass',
                builder: (context, state) => const GatePassScreen(),
              ),
            ],
          ),

          // Branch 2: Gruha AI Sovereign Advisor
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/gruha-ai',
                builder: (context, state) => const GruhaAiScreen(),
              ),
            ],
          ),

          // Branch 3: Financial Calculators
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tools/emi-calculator',
                builder: (context, state) => const EmiCalculatorScreen(),
              ),
            ],
          ),

          // Branch 4: Investor Profile & Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

