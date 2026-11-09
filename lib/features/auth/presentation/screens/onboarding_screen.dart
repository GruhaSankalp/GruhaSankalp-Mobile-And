import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sovereign_button.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': '100% Legal Clearance & 30-Year Title Search',
      'subtitle':
          'Every property is audited against 30-year SRO records, RERA registrations, and encumbrance certificates before listing.',
      'badge': '98/100 Cadastral Score',
      'icon': Icons.verified_user_outlined,
    },
    {
      'title': 'Direct Zero-Brokerage Transactions',
      'subtitle':
          'Connect directly with verified title deed owners and premier developers with institutional escrow guarantees.',
      'badge': 'Zero Commission',
      'icon': Icons.handshake_outlined,
    },
    {
      'title': 'Gruha AI Sovereign Property Advisor',
      'subtitle':
          'Query land survey numbers, check SRO guidance rates, and simulate stamp duty with our AI clearinghouse engine.',
      'badge': '24/7 AI Legal Assistant',
      'icon': Icons.smart_toy_outlined,
    },
  ];

  void _onNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ref.read(authNotifierProvider.notifier).completeOnboarding();
      context.go('/persona-selector');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).completeOnboarding();
              context.go('/persona-selector');
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Glassmorphic Trust Icon Container
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.navy950,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.navy950.withOpacity(0.12),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                slide['icon'] as IconData,
                                size: 64,
                                color: AppColors.gold500,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.gold50,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.gold500),
                          ),
                          child: Text(
                            slide['badge'] as String,
                            style: const TextStyle(
                              color: AppColors.gold600,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Title
                        Text(
                          slide['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy950,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Subtitle
                        Text(
                          slide['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Pagination Dots & CTA
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.gold500
                              : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SovereignButton(
                    text: _currentIndex == _slides.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    style: SovereignButtonStyle.primaryNavy,
                    onPressed: _onNext,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already verified? ',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(authNotifierProvider.notifier).completeOnboarding();
                          context.go('/login');
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.navy950,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
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
    );
  }
}

