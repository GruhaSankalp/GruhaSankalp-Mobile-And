import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('Investor Profile & Security'),
        backgroundColor: AppColors.navy950,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // User Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.navy950,
                      child: Text(
                        (user?.fullName?.isNotEmpty == true
                            ? user!.fullName![0]
                            : 'S'),
                        style: const TextStyle(
                          color: AppColors.gold500,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user?.fullName ?? 'Sovereign Investor',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified,
                                  size: 16, color: AppColors.verifiedEmerald),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.phoneNumber ?? '+91 98765 43210',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.gold50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.gold500),
                            ),
                            child: Text(
                              'ROLE: ${authState.selectedPersona.name.toUpperCase()}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.gold600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu Options
              _buildMenuSection(
                title: 'Sovereign Security & Assets',
                items: [
                  _MenuItem(
                    icon: Icons.shield_outlined,
                    title: '256-Bit Sovereign Document Vault',
                    subtitle: '14 Legal Deeds & EC Extracts Audited',
                    onTap: () {
                      context.showSnackBar('Opening Encrypted Legal Vault');
                    },
                  ),
                  _MenuItem(
                    icon: Icons.fingerprint,
                    title: 'Biometric Instant Unlock',
                    subtitle: 'Fingerprint & FaceID Enabled',
                    trailing: Switch(
                      value: true,
                      activeColor: AppColors.gold500,
                      onChanged: (val) {},
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.swap_horiz,
                    title: 'Switch Active Persona',
                    subtitle: 'Switch between Buyer, Tenant, or Owner',
                    onTap: () => context.push('/persona-selector'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildMenuSection(
                title: 'Financial & Clearinghouse Tools',
                items: [
                  _MenuItem(
                    icon: Icons.calculate_outlined,
                    title: 'Home Loan & Stamp Duty Calculator',
                    subtitle: 'Simulate EMIs and Telangana/Karnataka Duty',
                    onTap: () => context.push('/tools/emi-calculator'),
                  ),
                  _MenuItem(
                    icon: Icons.rule_folder_outlined,
                    title: 'Cadastral Guidance Rates',
                    subtitle: 'View Hyderabad corridor circle rates',
                    onTap: () {
                      context.showSnackBar('Kokapet: ₹8,200/sq.ft guidance rate');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign Out Button
              OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.alertRed),
              ).let((_) => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.alertRed),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.logout, color: AppColors.alertRed, size: 18),
                      label: const Text(
                        'Sign Out of Clearinghouse Vault',
                        style: TextStyle(
                          color: AppColors.alertRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () async {
                        await ref.read(authNotifierProvider.notifier).signOut();
                        if (context.mounted) context.go('/login');
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navy950,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: items.map((item) {
              return ListTile(
                leading: Icon(item.icon, color: AppColors.navy800, size: 22),
                title: Text(item.title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: Text(item.subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
                trailing: item.trailing ??
                    const Icon(Icons.arrow_forward_ios,
                        size: 13, color: AppColors.textMuted),
                onTap: item.onTap,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });
}

extension LetExtension<T> on T {
  R let<R>(R Function(T it) block) => block(this);
}

