import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.password});

  final String password;

  int get strength {
    if (password.length >= 10) return 3;
    if (password.length >= 7) return 2;
    if (password.isNotEmpty) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 6.h),
        Row(
          children: [
            Text(
              'قوة كلمة المرور',
              style: TextStyle(fontSize: 12.sp, color: AppColors.primaryDark),
            ),
            Spacer(),
            Text(
              strength == 0
                  ? 'اختر كلمة مرور قوية'
                  : strength == 1
                  ? 'ضعيفة'
                  : strength == 2
                  ? 'متوسطة'
                  : 'قوية',
              style: TextStyle(fontSize: 12.sp, color: AppColors.primaryDark),
            ),
            SizedBox(width: 6.w),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children:
              List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: index < strength
                          ? AppColors.primaryDark
                          : AppColors.borderLighter,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                );
              }).expand((widget) sync* {
                yield widget;
                if (widget != (List.generate(3, (_) {})).last) {
                  yield SizedBox(width: 6.w);
                }
              }).toList(),
        ),
        SizedBox(height: 6.h),
      ],
    );
  }
}
