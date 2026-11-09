import 'package:flutter/material.dart';

/// GruhaSankalp Sovereign Real Estate & Clearinghouse Color Tokens
/// Derived directly from the brand guidelines and design system specifications.
abstract class AppColors {
  // Sovereign Core (Navy Palette)
  static const Color navy950 = Color(0xFF071E36); // Primary headers, dark backgrounds, high-contrast CTA
  static const Color navy900 = Color(0xFF0B2948); // Container surfaces in dark mode, card header gradients
  static const Color navy800 = Color(0xFF123B63); // Secondary buttons, dark card borders
  static const Color navy700 = Color(0xFF1C4D7E); // Interactive states
  static const Color navy600 = Color(0xFF26629F); // Subtle accents

  // Regal Gold Palette
  static const Color gold600 = Color(0xFFC5941F); // Active hover states, interactive sliders
  static const Color gold500 = Color(0xFFD9A72C); // Primary brand accent, verified stamps, highlight badges
  static const Color gold400 = Color(0xFFE2B747); // Progress meters, secondary highlights
  static const Color gold100 = Color(0xFFF6E8B9); // Soft gold container background
  static const Color gold50  = Color(0xFFFAF5E4); // Badge background fills, highlighted card backdrops

  // Canvas & Surfaces
  static const Color canvasLight = Color(0xFFF7F9FC); // Ultra-clean light mode background (Snow Slate)
  static const Color surfaceWhite = Color(0xFFFFFFFF); // Crisp white elevated cards
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0); // Subtle 1px borders

  // Typography Tokens
  static const Color textDark = Color(0xFF17202A); // Primary typography, headers, price labels
  static const Color textMuted = Color(0xFF667085); // Subtitles, metadata, secondary stats
  static const Color textLight = Color(0xFFF8FAFC); // Typography on dark backgrounds

  // Verification & Status Metrics
  static const Color verifiedEmerald = Color(0xFF059669); // 95+ Cadastral legal scores, RERA verified pills
  static const Color emeraldBg = Color(0xFFECFDF5);
  static const Color warningAmber = Color(0xFFD97706); // In Review, title discrepancy alert
  static const Color amberBg = Color(0xFFFFFBEB);
  static const Color alertRed = Color(0xFFDC2626); // Title discrepancy warnings, encumbrance flagged
  static const Color redBg = Color(0xFFFEF2F2);
}

