import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum SovereignButtonStyle { primaryNavy, regalGold, outline }

class SovereignButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final SovereignButtonStyle style;
  final Widget? icon;
  final double height;
  final double? width;

  const SovereignButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.style = SovereignButtonStyle.primaryNavy,
    this.icon,
    this.height = 50.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide border;

    switch (style) {
      case SovereignButtonStyle.primaryNavy:
        bgColor = AppColors.navy950;
        fgColor = Colors.white;
        border = const BorderSide(color: AppColors.gold500, width: 1.0);
        break;
      case SovereignButtonStyle.regalGold:
        bgColor = AppColors.gold500;
        fgColor = AppColors.navy950;
        border = BorderSide.none;
        break;
      case SovereignButtonStyle.outline:
        bgColor = Colors.transparent;
        fgColor = AppColors.navy950;
        border = const BorderSide(color: AppColors.navy800, width: 1.2);
        break;
    }

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: bgColor.withOpacity(0.5),
          disabledForegroundColor: fgColor.withOpacity(0.5),
          elevation: style == SovereignButtonStyle.regalGold ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: border,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: fgColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

