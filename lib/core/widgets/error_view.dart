import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'sovereign_button.dart';

class SovereignErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const SovereignErrorView({
    super.key,
    this.title = 'Unable to Load Data',
    this.message = 'Please check your connection or try again shortly.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.redBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.alertRed.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 36,
                color: AppColors.alertRed,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 22),
              SovereignButton(
                text: 'Retry Connection',
                onPressed: onRetry,
                width: 180,
                height: 44,
                style: SovereignButtonStyle.primaryNavy,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

