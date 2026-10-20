import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Navy
  static const Color primaryNavy = Color(0xFF123B72);
  static const Color deepNavy = Color(0xFF082957);
  static const Color primaryBlue = Color(0xFF2675E8);
  static const Color cyanAccent = Color(0xFF39C6E8);

  // Functional & Accent Colors
  static const Color emeraldGreen = Color(0xFF19A878);
  static const Color warmGold = Color(0xFFF4B942);
  static const Color softLavender = Color(0xFFA88BEF);
  static const Color softCoral = Color(0xFFFF6B6B);

  // Background & Surfaces
  static const Color mainBackground = Color(0xFFF4F8FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Typography
  static const Color primaryText = Color(0xFF172B4D);
  static const Color secondaryText = Color(0xFF65748B);
  static const Color mutedText = Color(0xFF94A3B8);

  // Liquid Glass Tokens
  static final Color glassSurface = Colors.white.withOpacity(0.72);
  static final Color glassBorder = Colors.white.withOpacity(0.65);
  static final Color glassHighlight = Colors.white.withOpacity(0.9);
  static final Color glassDarkSurface = primaryNavy.withOpacity(0.85);

  // Subtle Gradients
  static const LinearGradient navyToBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepNavy, primaryNavy, primaryBlue],
  );

  static const LinearGradient blueToCyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, cyanAccent],
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF108A61), emeraldGreen],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE5A429), warmGold],
  );

  static const LinearGradient lavenderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B64E8), softLavender],
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFF0E3264),
      Color(0xFF1A56A8),
      Color(0xFF2675E8),
    ],
  );

  static const LinearGradient glassShineGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color(0x33FFFFFF),
    ],
  );
}
