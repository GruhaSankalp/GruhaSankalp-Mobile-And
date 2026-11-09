import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sovereign_button.dart';
import '../../domain/repositories/property_repository.dart';
import '../providers/property_provider.dart';

class FilterModal extends ConsumerStatefulWidget {
  const FilterModal({super.key});

  @override
  ConsumerState<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends ConsumerState<FilterModal> {
  int _selectedBhk = 3;
  double _minScore = 90;
  RangeValues _budgetRange = const RangeValues(10000000, 35000000);
  bool _directOwnerOnly = false;
  bool _reraOnly = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Modal Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cadastral Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy950,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedBhk = 0;
                      _minScore = 80;
                      _budgetRange = const RangeValues(5000000, 50000000);
                      _directOwnerOnly = false;
                      _reraOnly = false;
                    });
                  },
                  child: const Text('Reset All',
                      style: TextStyle(color: AppColors.textMuted)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Minimum Cadastral Trust Score Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Minimum Legal Trust Score',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '${_minScore.round()}/100+',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.verifiedEmerald,
                  ),
                ),
              ],
            ),
            Slider(
              value: _minScore,
              min: 80,
              max: 100,
              divisions: 20,
              activeColor: AppColors.verifiedEmerald,
              inactiveColor: AppColors.borderLight,
              onChanged: (val) => setState(() => _minScore = val),
            ),
            const SizedBox(height: 14),

            // Configuration (BHK)
            const Text(
              'Configuration (BHK)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [1, 2, 3, 4, 5].map((bhk) {
                final isSelected = _selectedBhk == bhk;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            isSelected ? AppColors.navy950 : Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.gold500
                              : AppColors.borderLight,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () => setState(() => _selectedBhk = bhk),
                      child: Text(
                        '$bhk BHK',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Checkbox options
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.gold500,
              title: const Text('RERA Registered Only',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              value: _reraOnly,
              onChanged: (val) => setState(() => _reraOnly = val ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.gold500,
              title: const Text('Direct Owner (Zero Brokerage)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              value: _directOwnerOnly,
              onChanged: (val) =>
                  setState(() => _directOwnerOnly = val ?? false),
            ),

            const SizedBox(height: 20),

            // Apply Button
            SovereignButton(
              text: 'Apply Sovereign Filters',
              style: SovereignButtonStyle.primaryNavy,
              onPressed: () {
                ref.read(propertyFilterProvider.notifier).state =
                    PropertyFilterCriteria(
                  minBhk: _selectedBhk == 0 ? null : _selectedBhk,
                  minCadastralScore: _minScore.round(),
                  reraOnly: _reraOnly,
                  directOwnerOnly: _directOwnerOnly,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
