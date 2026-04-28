import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class GradientCircle extends StatelessWidget {
  const GradientCircle({
    super.key,
    required this.gradient,
    this.selected = false,
    this.onTap,
  });

  final Gradient gradient;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 56.r,
        height: 56.r,
        decoration: BoxDecoration(
          gradient: gradient,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.primaryDark : Colors.white,
            width: selected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(selected ? 0.18 : 0.08),
              blurRadius: selected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: selected
            ? Icon(Icons.check_rounded, color: Colors.white, size: 22.sp)
            : null,
      ),
    );
  }
}
