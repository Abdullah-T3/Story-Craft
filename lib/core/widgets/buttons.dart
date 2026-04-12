import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppButtonStyle {
  filled,
  outlined,
  transparent,
}

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.filled,
    this.isLoading = false,
    this.backgroundColor,
    this.borderColor,
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
  final EdgeInsetsGeometry? margin;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? iconSpacing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bg = backgroundColor ??
        switch (style) {
          AppButtonStyle.filled => scheme.primary,
          AppButtonStyle.outlined => Colors.transparent,
          AppButtonStyle.transparent => Colors.transparent,
        };

    final border = borderColor ??
        switch (style) {
          AppButtonStyle.filled => scheme.primary,
          AppButtonStyle.outlined => scheme.outline,
          AppButtonStyle.transparent => Colors.transparent,
        };

    final spacing = iconSpacing ?? 8.w;

    final child = isLoading
        ? SizedBox(
            width: 18.w,
            height: 18.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                style == AppButtonStyle.filled
                    ? scheme.onPrimary
                    : scheme.primary,
              ),
            ),
          )
        : (prefixIcon == null && suffixIcon == null 
            ? Text(label)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[prefixIcon!,
                    SizedBox(width: spacing),
                  ],
                  Text(label),
                  if (suffixIcon != null) ...[
                    SizedBox(width: spacing),
                    suffixIcon!,
                  ],
                ],
              ));

    Widget button;
    switch (style) {
      case AppButtonStyle.filled:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: bg,
            side: BorderSide(color: border),
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
            side: BorderSide(color: border),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          ),
          child: child,
        );
        break;

      case AppButtonStyle.transparent:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          ),
          child: child,
        );
        break;
    }

    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: button,
    );
  }
}