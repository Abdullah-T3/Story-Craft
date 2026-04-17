import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_inline_loader.dart';

enum AppButtonStyle { filled, outlined, transparent }

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.filled,
    this.isLoading = false,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.borderWidth = 2,
    this.margin,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSpacing,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonStyle style;
  final bool isLoading;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double borderWidth;
  final EdgeInsetsGeometry? margin;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? iconSpacing;

  @override
  Widget build(BuildContext context) {
    final bg =
        backgroundColor ??
        switch (style) {
          AppButtonStyle.filled => AppColors.primaryDark,
          AppButtonStyle.outlined => Colors.transparent,
          AppButtonStyle.transparent => Colors.transparent,
        };

    final border =
        borderColor ??
        switch (style) {
          AppButtonStyle.filled => AppColors.primaryDark,
          AppButtonStyle.outlined => AppColors.primaryDark,
          AppButtonStyle.transparent => Colors.transparent,
        };

    final fg =
        textColor ??
        switch (style) {
          AppButtonStyle.filled => Colors.white,
          AppButtonStyle.outlined => AppColors.primaryDark,
          AppButtonStyle.transparent => AppColors.primaryDark,
        };

    final spacing = iconSpacing ?? 8.w;

    final child = isLoading
        ? AppInlineLoader(size: 18, color: fg, strokeWidth: 2)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                SizedBox(width: spacing),
              ],
              Text(label, style: TextStyle(color: fg)),
              if (suffixIcon != null) ...[
                SizedBox(width: spacing),
                suffixIcon!,
              ],
            ],
          );

    Widget button;

    switch (style) {
      case AppButtonStyle.filled:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            side: BorderSide(color: border, width: borderWidth),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          ),
          child: child,
        );
        break;

      case AppButtonStyle.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            side: BorderSide(color: border, width: borderWidth),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          ),
          child: child,
        );
        break;

      case AppButtonStyle.transparent:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: fg,
            side: BorderSide(color: border, width: borderWidth),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          ),
          child: child,
        );
        break;
    }

    return Container(margin: margin ?? EdgeInsets.zero, child: button);
  }
}
