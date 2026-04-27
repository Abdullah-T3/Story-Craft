import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class ReaderBottomBar extends StatelessWidget {
  const ReaderBottomBar({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.onPrevious,
    required this.onNext,
    required this.onFinish,
  });

  final int currentIndex;
  final int total;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == total - 1;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Row(
          children: [
            // RTL: previous on the right, next on the left.
            _NavButton(
              icon: Icons.arrow_forward_rounded,
              onTap: isLast ? onFinish : onNext,
              isPrimary: true,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : (currentIndex + 1) / total,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
            ),
            _NavButton(
              icon: Icons.arrow_back_rounded,
              onTap: isFirst ? null : onPrevious,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        width: 56.r,
        height: 56.r,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.surfaceContainerHigh
              : (isPrimary ? AppColors.primaryDark : Colors.white),
          shape: BoxShape.circle,
          boxShadow: disabled
              ? const []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Icon(
          icon,
          color: disabled
              ? AppColors.textTertiary
              : (isPrimary ? Colors.white : AppColors.textPrimary),
          size: 24.sp,
        ),
      ),
    );
  }
}
