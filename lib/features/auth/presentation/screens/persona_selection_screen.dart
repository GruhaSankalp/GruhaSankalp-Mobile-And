import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sovereign_button.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart';

class PersonaSelectionScreen extends ConsumerStatefulWidget {
  const PersonaSelectionScreen({super.key});

  @override
  ConsumerState<PersonaSelectionScreen> createState() =>
      _PersonaSelectionScreenState();
}

class _PersonaSelectionScreenState
    extends ConsumerState<PersonaSelectionScreen> {
  UserPersona _selected = UserPersona.buyer;

  final List<Map<String, dynamic>> _personas = [
    {
      'persona': UserPersona.buyer,
      'title': 'Home Buyer / Sovereign Investor',
      'subtitle':
          'Explore 95+ Cadastral Score homes with 30-year SRO legal audit reports.',
      'badge': 'Legal Score Included',
      'icon': Icons.home_work_outlined,
    },
    {
      'persona': UserPersona.tenant,
      'title': 'Verified Rental Tenant',
      'subtitle':
          'Find premium gated flats and villas with zero deposit brokerage.',
      'badge': 'Zero Brokerage',
      'icon': Icons.key_outlined,
    },
    {
      'persona': UserPersona.owner,
      'title': 'Individual Property Owner',
      'subtitle':
          'Post your property directly to pre-verified buyers with dynamic gatepasses.',
      'badge': 'Direct Buyer Leads',
      'icon': Icons.real_estate_agent_outlined,
    },
    {
      'persona': UserPersona.builder,
      'title': 'Builder / Channel Partner',
      'subtitle':
          'Manage tower stacking inventory, lead pipelines, and visitor QR gates.',
      'badge': 'Tower Matrix CRM',
      'icon': Icons.apartment_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('Tailor Your Experience'),
        backgroundColor: AppColors.navy950,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Your Primary Role',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy950,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'We customize search filters, legal workflows, and dashboards for you.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 18),

              Expanded(
                child: ListView.separated(
                  itemCount: _personas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _personas[index];
                    final persona = item['persona'] as UserPersona;
                    final isSelected = _selected == persona;

                    return GestureDetector(
                      onTap: () => setState(() => _selected = persona),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold500
                                : AppColors.borderLight,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.gold500.withOpacity(0.15),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.navy950
                                    : AppColors.canvasLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: isSelected
                                    ? AppColors.gold500
                                    : AppColors.navy800,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] as String,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.gold500,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['subtitle'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.gold50
                                          : AppColors.canvasLight,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['badge'] as String,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? AppColors.gold600
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              SovereignButton(
                text: 'Continue as ${_selected.name.toUpperCase()}',
                style: SovereignButtonStyle.primaryNavy,
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).setPersona(_selected);
                  context.go('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

