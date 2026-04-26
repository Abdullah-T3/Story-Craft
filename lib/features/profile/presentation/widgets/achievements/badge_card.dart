import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/profile/domain/entities/badge.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key, required this.badge});

  final AchievementBadge badge;

  @override
  Widget build(BuildContext context) {
    final keyName = _keyForKind(badge.kind);
    final namedArgs = _namedArgsFor(badge);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: badge.color.withOpacity(badge.unlocked ? 0.15 : 0.10),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  badge.icon,
                  color: badge.unlocked
                      ? badge.color
                      : AppColors.textTertiary,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'profile.achievements.badges.$keyName.name'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: badge.unlocked
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'profile.achievements.badges.$keyName.subtitle'
                    .tr(namedArgs: namedArgs),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (!badge.unlocked)
          Positioned(
            top: 8.h,
            left: 8.w,
            child: Icon(
              Icons.lock_rounded,
              size: 14.sp,
              color: AppColors.textTertiary,
            ),
          ),
      ],
    );
  }

  String _keyForKind(BadgeKind kind) => switch (kind) {
    BadgeKind.consistent => 'consistent',
    BadgeKind.creativeWriter => 'creativeWriter',
    BadgeKind.voraciousReader => 'voraciousReader',
    BadgeKind.littleWorld => 'littleWorld',
    BadgeKind.monthHero => 'monthHero',
    BadgeKind.storyStar => 'storyStar',
  };

  Map<String, String> _namedArgsFor(AchievementBadge b) {
    final v = b.metricValue.toString();
    return switch (b.kind) {
      BadgeKind.consistent => {'days': v},
      BadgeKind.creativeWriter ||
      BadgeKind.voraciousReader ||
      BadgeKind.littleWorld ||
      BadgeKind.storyStar => {'count': v},
      BadgeKind.monthHero => {'rank': v},
    };
  }
}
