import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/sovereign_button.dart';

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  double _propertyValue = 20000000; // 2 Cr
  double _downPaymentPercent = 20.0; // 20%
  double _tenureYears = 20.0; // 20 years
  double _interestRate = 8.5; // 8.5%
  String _selectedState = 'Telangana (7.5%)';

  double get _loanAmount =>
      _propertyValue * (1 - (_downPaymentPercent / 100));

  double get _monthlyEmi {
    final principal = _loanAmount;
    final r = (_interestRate / 12) / 100;
    final n = _tenureYears * 12;
    if (r == 0) return principal / n;
    final emi = (principal * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
    return emi;
  }

  double get _stampDutyAmount {
    final rate = _selectedState.startsWith('Telangana') ? 0.075 : 0.056;
    return _propertyValue * rate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('EMI & Stamp Duty Calculator'),
        backgroundColor: AppColors.navy950,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Result Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.navy950,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold500, width: 1.2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'ESTIMATED MONTHLY EMI',
                      style: TextStyle(
                        color: AppColors.gold400,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.formatFull(_monthlyEmi.round()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.navy800),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryItem(
                            'Principal Loan', CurrencyFormatter.formatCompact(_loanAmount)),
                        _buildSummaryItem(
                            'State Stamp Duty',
                            CurrencyFormatter.formatCompact(_stampDutyAmount)),
                        _buildSummaryItem('Total Tenure', '${_tenureYears.round()} Yrs'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Property Consideration Slider
              _buildSliderSection(
                title: 'Property Consideration',
                valueText: CurrencyFormatter.formatCompact(_propertyValue),
                value: _propertyValue,
                min: 3000000,
                max: 100000000,
                onChanged: (val) => setState(() => _propertyValue = val),
              ),

              // Down Payment Slider
              _buildSliderSection(
                title: 'Down Payment',
                valueText: '${_downPaymentPercent.round()}% (${CurrencyFormatter.formatCompact(_propertyValue * (_downPaymentPercent / 100))})',
                value: _downPaymentPercent,
                min: 10,
                max: 50,
                onChanged: (val) => setState(() => _downPaymentPercent = val),
              ),

              // Tenure Slider
              _buildSliderSection(
                title: 'Loan Tenure',
                valueText: '${_tenureYears.round()} Years',
                value: _tenureYears,
                min: 5,
                max: 30,
                onChanged: (val) => setState(() => _tenureYears = val),
              ),

              // Interest Rate Slider
              _buildSliderSection(
                title: 'Interest Rate',
                valueText: '${_interestRate.toStringAsFixed(1)}% p.a.',
                value: _interestRate,
                min: 6.5,
                max: 13.0,
                onChanged: (val) => setState(() => _interestRate = val),
              ),

              const SizedBox(height: 20),

              // State Registration & Stamp Duty Switcher
              const Text(
                'Registration State Guideline',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy950,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Telangana (7.5%)'),
                      selected: _selectedState.startsWith('Telangana'),
                      selectedColor: AppColors.gold50,
                      side: BorderSide(
                        color: _selectedState.startsWith('Telangana')
                            ? AppColors.gold500
                            : AppColors.borderLight,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedState = 'Telangana (7.5%)');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Karnataka (5.6%)'),
                      selected: _selectedState.startsWith('Karnataka'),
                      selectedColor: AppColors.gold50,
                      side: BorderSide(
                        color: _selectedState.startsWith('Karnataka')
                            ? AppColors.gold500
                            : AppColors.borderLight,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedState = 'Karnataka (5.6%)');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              SovereignButton(
                text: 'Apply Pre-Approved Bank Loan',
                style: SovereignButtonStyle.primaryNavy,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Checking loan pre-approval with institutional partner banks...'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildSliderSection({
    required String title,
    required String valueText,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
            Text(valueText,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy950)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.navy950,
          inactiveColor: AppColors.borderLight,
          onChanged: onChanged,
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
