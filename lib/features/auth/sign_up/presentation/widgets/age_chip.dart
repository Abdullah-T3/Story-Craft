import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class AgeChip extends StatelessWidget {
  const AgeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryDark : AppColors.secondaryContainer.withValues(
              alpha: 0.2,
            ),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: selected ? AppColors.primaryDark : AppColors.borderLighter,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'سنوات',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
