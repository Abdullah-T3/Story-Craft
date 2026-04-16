import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

/// A reusable, themed text field used throughout the app.
///
/// Features:
/// - Optional label rendered above the field
/// - Leading / trailing icon slots
/// - Password mode: auto-manages obscure text + visibility-toggle button
/// - RTL-aware layout via [layoutDirection]
/// - Consistent border, fill, and error colours from [AppColors]
///
/// Example — email field:
/// ```dart
/// AppTextField(
///   controller: _emailController,
///   label: 'البريد الإلكتروني',
///   hint: 'أدخل بريدك هنا',
///   trailingIcon: const Icon(Icons.mail_outline_rounded),
///   keyboardType: TextInputType.emailAddress,
///   validator: (v) { … },
/// )
/// ```
///
/// Example — password field:
/// ```dart
/// AppTextField(
///   controller: _passwordController,
///   label: 'كلمة المرور',
///   hint: 'كلمة المرور السرية',
///   trailingIcon: const Icon(Icons.lock_outline_rounded),
///   isPassword: true,
///   validator: (v) { … },
/// )
/// ```
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.controller,
    this.label,
    this.hint,
    this.trailingIcon,
    this.leadingIcon,
    this.keyboardType,
    this.textDirection,
    this.backgroundColor,
    this.textAlign = TextAlign.start,
    this.layoutDirection = TextDirection.rtl,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.textInputAction,
    this.inputFormatters,
    super.key,
  }) : assert(
         !isPassword || maxLines == 1,
         'Password fields cannot be multiline.',
       );

  /// The controller for reading / writing the field value.
  final TextEditingController controller;

  /// Optional label rendered above the field.
  final String? label;

  /// Placeholder text shown when the field is empty.
  final String? hint;

  /// Icon shown on the **trailing** (end) side of the field.
  /// In an RTL layout this appears on the left; in LTR on the right.
  final Widget? trailingIcon;

  /// Icon shown on the **leading** (start) side.
  /// When [isPassword] is true this slot is reserved for the
  /// visibility-toggle button.
  final Widget? leadingIcon;

  final TextInputType? keyboardType;

  /// Direction of the typed text (not the widget layout).
  /// Defaults to null (inherits ambient direction).
  final TextDirection? textDirection;

  final TextAlign textAlign;

  /// Layout direction for the label and the field row.
  /// Defaults to [TextDirection.rtl] since the app is Arabic-first.
  final TextDirection layoutDirection;

  /// When true the field hides its text and shows a visibility-toggle
  /// button on the leading side. [trailingIcon] should be a lock icon.
  final bool isPassword;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final Color? backgroundColor;
  final bool autofocus;
  final bool readOnly;

  /// Number of lines. Must be 1 when [isPassword] is true.
  final int maxLines;

  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.layoutDirection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Label ──────────────────────────────────────────────────────────
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
          ],

          // ── Field ──────────────────────────────────────────────────────────
          TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textDirection: widget.textDirection,
            textAlign: widget.textAlign,
            obscureText: widget.isPassword && _obscure,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
              // Trailing — content icon (mail, lock, search …)
              suffixIcon: widget.trailingIcon != null
                  ? IconTheme(
                      data: const IconThemeData(color: AppColors.primaryDark),
                      child: widget.trailingIcon!,
                    )
                  : null,
              // Leading — visibility toggle for passwords, or custom icon
              prefixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textHint,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : widget.leadingIcon,
              filled: true,
              fillColor: widget.backgroundColor ?? Colors.white,
              border: _border(),
              enabledBorder: _border(
                color: AppColors.primaryDark.withValues(alpha: 0.3),
              ),
              focusedBorder: _border(color: AppColors.primaryDark, width: 2),
              errorBorder: _border(color: Theme.of(context).colorScheme.error),
              focusedErrorBorder: _border(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: color != null
          ? BorderSide(color: color, width: width)
          : BorderSide.none,
    );
  }
}
