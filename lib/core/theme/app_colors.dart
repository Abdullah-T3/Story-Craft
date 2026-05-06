import 'package:flutter/material.dart';

/// Design system colors based on provided image.
abstract final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1D9E75);
  static const Color secondary = Color(0xFFDB5A30);
  static const Color tertiary = Color(0xFFEF9F27);
  static const Color neutralSurface = Color(0xFFFFFBF5);

  /// Containers (generated lighter tones for UI surfaces)
  static const Color primaryContainer = Color(0xFFD6F0E8);
  static const Color onPrimaryContainer = Color(0xFF0F4F3A);

  static const Color secondaryContainer = Color(0xFFF6D2C8);
  static const Color onSecondaryContainer = Color(0xFF5A2313);

  static const Color tertiaryContainer = Color(0xFFFBE2C2);
  static const Color onTertiaryContainer = Color(0xFF5A3A05);

  /// Neutral UI surfaces (light gray from layout)
  static const Color surfaceContainerHigh = Color(0xFFEDEBE7);

  static const Color onSecondary = Color(0xFF2D2A26);

  /// Extended palette — screen-level shades
  /// Warm off-white used as header/section background
  static const Color headerBackground = Color(0xFFFDF6E3);

  /// Lighter tint of [primary] — icon circle backgrounds
  static const Color primaryMuted = Color(0xFF74C69D);

  /// Darker shade of [primary] — prominent buttons, icon accents, borders
  static const Color primaryDark = Color(0xFF2D6A4F);

  /// Lighter tint of [secondary] — forgot-password link, sign-up button
  static const Color secondaryMuted = Color(0xFFE07A5F);

  /// Text colours
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFFAAAAAA);
  static const Color textTertiary = Color(0xFF999999);

  /// Border / divider colours
  static const Color borderLight = Color(0xFFCCCCCC);
  static const Color borderLighter = Color(0xFFDDDDDD);

  /// Destructive / error
  static const Color error = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFDECEA);
}
