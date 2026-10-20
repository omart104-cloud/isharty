import 'package:flutter/material.dart';

class AppSpacing {
  // Spacing Scale
  static const double micro = 4.0;
  static const double compact = 8.0;
  static const double small = 12.0;
  static const double standard = 16.0;
  static const double medium = 20.0;
  static const double section = 24.0;
  static const double large = 32.0;
  static const double huge = 48.0;

  // Border Radii (18-28px as required for liquid glass aesthetic)
  static const double radiusSmall = 14.0;
  static const double radiusMedium = 18.0;
  static const double radiusLarge = 24.0;
  static const double radiusCard = 22.0;
  static const double radiusPill = 999.0;

  static final BorderRadius roundedMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius roundedLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius roundedCard = BorderRadius.circular(radiusCard);
  static final BorderRadius roundedPill = BorderRadius.circular(radiusPill);

  // Soft Layered Shadows
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0C123B72),
      blurRadius: 16,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color(0x14123B72),
      blurRadius: 24,
      offset: Offset(0, 10),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Color(0x08123B72),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Color(0x18082957),
      blurRadius: 30,
      offset: Offset(0, 12),
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Color(0x0A2675E8),
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> glowShadow = [
    BoxShadow(
      color: Color(0x332675E8),
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];
}
