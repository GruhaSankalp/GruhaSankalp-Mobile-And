import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Check initialization status and navigate
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      final authState = ref.read(authNotifierProvider);
      if (authState.isAuthenticated) {
        context.go('/home');
      } else if (!authState.hasSeenOnboarding) {
        context.go('/onboarding');
      } else {
        context.go('/persona-selector');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy950,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Subtle background decorative radial halo
              Center(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.navy800.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Central Brand Identity Reveal
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sovereign Monogram Emblem
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.navy900,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold500, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold500.withOpacity(0.25),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_balance_outlined,
                          size: 44,
                          color: AppColors.gold500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Typography
                    const Text(
                      'GruhaSankalp',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sovereign Real Estate & Cadastral Clearinghouse',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Security & Encryption Badge
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.navy800,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.gold500),
                        minHeight: 2.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.lock_outline, size: 13, color: Color(0xFF64748B)),
                        SizedBox(width: 6),
                        Text(
                          '256-BIT SOVEREIGN ESCROW VAULT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

