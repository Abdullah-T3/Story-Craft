import 'package:flutter/material.dart';
import 'package:story_craft/core/theme/app_colors.dart';

/// Custom [ThemeExtension] that carries app-specific design tokens not covered
/// by Flutter's [ColorScheme]. Access via [BuildContext.appTheme].
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.headerBackground,
    required this.primaryMuted,
    required this.primaryDark,
    required this.secondaryMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textTertiary,
    required this.borderLight,
    required this.borderLighter,
  });

  final Color headerBackground;

  /// Lighter tint of primary — icon circle backgrounds, badges.
  final Color primaryMuted;

  /// Darker shade of primary — prominent buttons, icon accents, focused borders.
  final Color primaryDark;

  /// Lighter tint of secondary — links, accent buttons (e.g. sign-up, forgot password).
  final Color secondaryMuted;

  /// Text colours — four-level hierarchy.
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textTertiary;

  /// Border / divider colours.
  final Color borderLight;
  final Color borderLighter;

  // ── Static instances ────────────────────────────────────────────────────────

  static const light = AppThemeExtension(
    headerBackground: AppColors.headerBackground,
    primaryMuted: AppColors.primaryMuted,
    primaryDark: AppColors.primaryDark,
    secondaryMuted: AppColors.secondaryMuted,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textHint: AppColors.textHint,
    textTertiary: AppColors.textTertiary,
    borderLight: AppColors.borderLight,
    borderLighter: AppColors.borderLighter,
  );

  static const dark = AppThemeExtension(
    headerBackground: Color(0xFF1E2A24),
    primaryMuted: Color(0xFF3D8C6A),
    primaryDark: Color(0xFF74C69D),
    secondaryMuted: Color(0xFFEF9F83),
    textPrimary: Color(0xFFE6E1E6),
    textSecondary: Color(0xFFAAAAAA),
    textHint: Color(0xFF6B6B6B),
    textTertiary: Color(0xFF888888),
    borderLight: Color(0xFF3A3A3A),
    borderLighter: Color(0xFF4A4A4A),
  );

  // ── ThemeExtension overrides ────────────────────────────────────────────────

  @override
  AppThemeExtension copyWith({
    Color? headerBackground,
    Color? primaryMuted,
    Color? primaryDark,
    Color? secondaryMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? textTertiary,
    Color? borderLight,
    Color? borderLighter,
  }) {
    return AppThemeExtension(
      headerBackground: headerBackground ?? this.headerBackground,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      primaryDark: primaryDark ?? this.primaryDark,
      secondaryMuted: secondaryMuted ?? this.secondaryMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      textTertiary: textTertiary ?? this.textTertiary,
      borderLight: borderLight ?? this.borderLight,
      borderLighter: borderLighter ?? this.borderLighter,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      headerBackground: Color.lerp(
        headerBackground,
        other.headerBackground,
        t,
      )!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      secondaryMuted: Color.lerp(secondaryMuted, other.secondaryMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      borderLighter: Color.lerp(borderLighter, other.borderLighter, t)!,
    );
  }
}

/// Convenience accessor — `context.appTheme.primaryDark` instead of
/// `Theme.of(context).extension<AppThemeExtension>()!.primaryDark`.
extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
