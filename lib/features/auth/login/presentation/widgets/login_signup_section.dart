import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class LoginSignUpSection extends StatelessWidget {
  const LoginSignUpSection({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ليس لديك حساب؟',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 48.h,
          width: 200.w,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondaryMuted,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('إنشاء حساب جديد'),
          ),
        ),
      ],
    );
  }
}
