import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CadastralTrustBadge extends StatelessWidget {
  final int score; // 0 to 100
  final bool showLabel;
  final bool compact;

  const CadastralTrustBadge({
    super.key,
    required this.score,
    this.showLabel = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;
    String statusText;

    if (score >= 90) {
      color = AppColors.verifiedEmerald;
      bgColor = AppColors.emeraldBg;
      statusText = 'Institutional Clearance';
    } else if (score >= 75) {
      color = AppColors.warningAmber;
      bgColor = AppColors.amberBg;
      statusText = 'Under Review';
    } else {
      color = AppColors.alertRed;
      bgColor = AppColors.redBg;
      statusText = 'Title Discrepancy';
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              '$score/100',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            '$score/100',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Container(width: 3, height: 3, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(
              statusText,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

