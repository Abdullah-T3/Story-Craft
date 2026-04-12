import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class LoginOrDivider extends StatelessWidget {
  const LoginOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.borderLight,
            thickness: 1,
            endIndent: 12.w,
          ),
        ),
        Text(
          'او',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textTertiary),
        ),
        Expanded(
          child: Divider(
            color: AppColors.borderLight,
            thickness: 1,
            indent: 12.w,
          ),
        ),
      ],
    );
  }
}
