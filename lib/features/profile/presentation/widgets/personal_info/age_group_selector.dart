import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class AgeGroupSelector extends StatelessWidget {
  const AgeGroupSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  static const List<String> options = ['4-6', '7-9', '10-12'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((opt) {
        final selected = opt == value;
        return GestureDetector(
          onTap: () => onChanged(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryDark : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: selected ? AppColors.primaryDark : AppColors.borderLight,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
