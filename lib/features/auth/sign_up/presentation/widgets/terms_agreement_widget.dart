import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class TermsCheckboxWidget extends StatelessWidget {
  const TermsCheckboxWidget({
    super.key,
    required this.agreed,
    required this.onToggle,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final bool agreed;
  final VoidCallback onToggle;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: AppColors.borderLighter),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// checkbox
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: agreed
                    ? AppColors.primaryDark
                    : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.borderLighter),
              ),
              child: agreed
                  ? Icon(Icons.check, size: 18.w, color: Colors.white)
                  : null,
            ),
        
            SizedBox(width: 12.w),
            Expanded(
              child: RichText(
                textDirection: TextDirection.rtl,
                softWrap: true,
                maxLines: 2,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'أوافق على '),
                    TextSpan(
                      text: 'شروط الخدمة',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = onTermsTap,
                    ),
        
                    const TextSpan(text: ' و '),
        
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = onPrivacyTap,
                    ),
        
                    const TextSpan(text: ' لضمان بيئة آمنة لطفلي \n'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}