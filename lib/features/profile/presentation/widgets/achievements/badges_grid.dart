import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/profile/domain/entities/badge.dart';
import 'package:story_craft/features/profile/presentation/widgets/achievements/badge_card.dart';

class BadgesGrid extends StatelessWidget {
  const BadgesGrid({
    super.key,
    required this.badges,
    required this.unlocked,
    required this.total,
  });

  final List<AchievementBadge> badges;
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  LocaleKeys.common_showAll.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                LocaleKeys.profile_achievements_badgesProgress.tr(
                  namedArgs: {
                    'earned': unlocked.toString(),
                    'total': total.toString(),
                  },
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badges.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (_, i) => BadgeCard(badge: badges[i]),
          ),
        ],
      ),
    );
  }
}
