import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/cadastral_trust_badge.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/property_provider.dart';

class PropertyComparisonScreen extends ConsumerWidget {
  const PropertyComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesListProvider);

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('Property Comparison Matrix'),
        backgroundColor: AppColors.navy950,
      ),
      body: propertiesAsync.when(
        data: (properties) {
          if (properties.length < 2) {
            return const Center(
              child: Text('Need at least 2 properties to compare.'),
            );
          }

          final p1 = properties[0];
          final p2 = properties[1];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comparison Header Cards
                Row(
                  children: [
                    Expanded(child: _buildPropertyHeaderCard(p1)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildPropertyHeaderCard(p2)),
                  ],
                ),
                const SizedBox(height: 24),

                // Comparison Attribute Rows
                const Text(
                  'Cadastral Legal & Title Metrics',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy950,
                  ),
                ),
                const SizedBox(height: 10),

                _buildComparisonRow(
                  'Legal Clearance Score',
                  '${p1.legalTrustScore}/100',
                  '${p2.legalTrustScore}/100',
                  winnerIndex: p1.legalTrustScore >= p2.legalTrustScore ? 0 : 1,
                ),
                _buildComparisonRow(
                  'Price per Sq.Ft',
                  CurrencyFormatter.formatRatePerSqFt(p1.pricePerSqFt),
                  CurrencyFormatter.formatRatePerSqFt(p2.pricePerSqFt),
                  winnerIndex: p1.pricePerSqFt <= p2.pricePerSqFt ? 0 : 1,
                ),
                _buildComparisonRow(
                  'Carpet Area',
                  '${p1.carpetArea} sq.ft',
                  '${p2.carpetArea} sq.ft',
                  winnerIndex: p1.carpetArea >= p2.carpetArea ? 0 : 1,
                ),
                _buildComparisonRow(
                  '30-Year EC Status',
                  '100% Clean',
                  '100% Clean',
                ),
                _buildComparisonRow(
                  'Direct Owner / Zero Fee',
                  p1.isDirectOwner ? 'Yes' : 'No',
                  p2.isDirectOwner ? 'Yes' : 'No',
                ),
                _buildComparisonRow(
                  'Possession Timeline',
                  p1.possessionStatus,
                  p2.possessionStatus,
                ),
              ],
            ),
          );
        },
        loading: () => const SovereignLoadingIndicator(),
        error: (_, __) => const Center(child: Text('Error loading matrix')),
      ),
    );
  }

  Widget _buildPropertyHeaderCard(dynamic p) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CadastralTrustBadge(score: p.legalTrustScore, compact: true),
          const SizedBox(height: 8),
          Text(
            p.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            CurrencyFormatter.formatCompact(p.price),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.navy950,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String label,
    String val1,
    String val2, {
    int? winnerIndex,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  val1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: winnerIndex == 0
                        ? AppColors.verifiedEmerald
                        : AppColors.textDark,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  val2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: winnerIndex == 1
                        ? AppColors.verifiedEmerald
                        : AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
