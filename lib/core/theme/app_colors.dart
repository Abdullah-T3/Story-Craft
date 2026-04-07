import 'package:flutter/material.dart';

/// Design system colors (light theme baseline).
///
/// Neutral in the guide is `#FDFCFO` (invalid hex); spec uses an off-white cream → `#FDFCF0`.
abstract final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF7C73E6);
  static const Color secondary = Color(0xFFFFD166);
  static const Color tertiary = Color(0xFFEF476F);
  static const Color neutralSurface = Color(0xFFFDFCF0);

  /// Slightly muted primary for containers / tonal surfaces.
  static const Color primaryContainer = Color(0xFFE8E6FA);

  static const Color onPrimaryContainer = Color(0xFF2B2758);

  /// Light gold tint for secondary containers.
  static const Color secondaryContainer = Color(0xFFFFF3D6);

  static const Color onSecondaryContainer = Color(0xFF3D3420);

  /// Soft pink tint for tertiary containers.
  static const Color tertiaryContainer = Color(0xFFFFD9E1);

  static const Color onTertiaryContainer = Color(0xFF5F1128);

  /// Search fields / muted controls (light gray from guide).
  static const Color surfaceContainerHigh = Color(0xFFE8E8EE);

  static const Color onSecondary = Color(0xFF2D2A26);
}
