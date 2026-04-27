import 'package:flutter/material.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class GradientCircle extends StatelessWidget {
  const GradientCircle({
    required this.gradient,
    this.selected = false,
    this.onTap,
    super.key,
  });

  final Gradient gradient;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: selected ? 52 : 46,
        height: selected ? 52 : 46,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }
}