import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class EditorButtons extends StatelessWidget {
  const EditorButtons({
    super.key,
    required this.onAddPage,
    required this.onEditText,
  });

  final VoidCallback onAddPage;
  final VoidCallback onEditText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ActionButton(
            icon: Icons.text_fields_rounded,
            color: AppColors.tertiary,
            onTap: onEditText,
          ),
          SizedBox(width: 12.w),
          _ActionButton(
            icon: Icons.add_rounded,
            color: AppColors.primaryDark,
            onTap: onAddPage,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.30),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24.sp),
      ),
    );
  }
}
