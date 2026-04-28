import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class TextEditorToolbar extends StatelessWidget {
  const TextEditorToolbar({
    super.key,
    required this.onBold,
    required this.onAlignLeft,
    required this.onAlignCenter,
    required this.onAlignRight,
    required this.onColor,
  });

  final VoidCallback onBold;
  final VoidCallback onAlignLeft;
  final VoidCallback onAlignCenter;
  final VoidCallback onAlignRight;
  final VoidCallback onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.format_bold,
              color: AppColors.primaryDark,
              size: 20.sp,
            ),
            onPressed: onBold,
          ),
          IconButton(
            icon: Icon(
              Icons.format_align_right,
              color: AppColors.primaryDark,
              size: 20.sp,
            ),
            onPressed: onAlignRight,
          ),
          IconButton(
            icon: Icon(
              Icons.format_align_center,
              color: AppColors.primaryDark,
              size: 20.sp,
            ),
            onPressed: onAlignCenter,
          ),
          IconButton(
            icon: Icon(
              Icons.format_align_left,
              color: AppColors.primaryDark,
              size: 20.sp,
            ),
            onPressed: onAlignLeft,
          ),
          IconButton(
            icon: Icon(
              Icons.color_lens_outlined,
              color: AppColors.primaryDark,
              size: 20.sp,
            ),
            onPressed: onColor,
          ),
        ],
      ),
    );
  }
}
