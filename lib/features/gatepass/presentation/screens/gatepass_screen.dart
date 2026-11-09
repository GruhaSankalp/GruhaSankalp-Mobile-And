import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sovereign_button.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../providers/gatepass_provider.dart';

class GatePassScreen extends ConsumerWidget {
  const GatePassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passes = ref.watch(activeGatePassesProvider);

    if (passes.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.canvasLight,
        appBar: AppBar(
          title: const Text('Sovereign Gate Passes'),
          backgroundColor: AppColors.navy950,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.qr_code_2, size: 54, color: AppColors.textMuted),
              SizedBox(height: 12),
              Text(
                'No Active Gate Passes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy950,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Schedule a site visit from any verified listing to issue your digital pass.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final pass = passes.first;

    return Scaffold(
      backgroundColor: AppColors.navy950,
      appBar: AppBar(
        title: const Text('Digital Sovereign Gate Pass'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Column(
            children: [
              // Boarding-Pass style Ticket Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold500.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Top Sovereign Header Banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      color: AppColors.navy900,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.security,
                                  color: AppColors.gold500, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'OFFICIAL GATE ACCESS PASS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.emeraldBg,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'VERIFIED',
                              style: TextStyle(
                                color: AppColors.verifiedEmerald,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Large Security Passcode
                          Text(
                            pass.passCode,
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy950,
                              letterSpacing: 4.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: pass.passCode));
                              context.showSnackBar('Passcode copied to clipboard');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.copy, size: 13, color: AppColors.gold600),
                                SizedBox(width: 4),
                                Text(
                                  'Tap to copy passcode',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.gold600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Dynamic Encrypted QR Code
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.gold500, width: 1.5),
                            ),
                            child: QrImageView(
                              data:
                                  'https://clearinghouse.gruhasankalp.com/gate/${pass.passCode}',
                              version: QrVersions.auto,
                              size: 170.0,
                              foregroundColor: AppColors.navy950,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Dynamic QR refreshes for security clearance',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Perforated Divider
                          Row(
                            children: List.generate(
                              24,
                              (index) => Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  height: 1.5,
                                  color: AppColors.borderLight,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Ticket Metadata Table
                          _buildPassMetaRow(
                              'Property', pass.propertyTitle, isBold: true),
                          const SizedBox(height: 10),
                          _buildPassMetaRow('Unit & Tower', pass.propertyAddress),
                          const SizedBox(height: 10),
                          _buildPassMetaRow('Visitor Name', pass.visitorName),
                          const SizedBox(height: 10),
                          _buildPassMetaRow('Vehicle Number', pass.vehicleNumber),
                          const SizedBox(height: 10),
                          _buildPassMetaRow('Scheduled Slot', pass.timeSlot),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              SovereignButton(
                text: 'Add to Google Wallet',
                style: SovereignButtonStyle.regalGold,
                icon: const Icon(Icons.wallet, size: 18),
                onPressed: () {
                  context.showSnackBar('Gatepass added to Google Wallet');
                },
              ),
              const SizedBox(height: 10),
              SovereignButton(
                text: 'Turn-by-turn Gate Navigation',
                style: SovereignButtonStyle.outline,
                icon: const Icon(Icons.navigation_outlined,
                    size: 18, color: Colors.white),
                onPressed: () {
                  context.showSnackBar('Launching Google Maps to visitor gate');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassMetaRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.navy950,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

