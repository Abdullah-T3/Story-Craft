import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/parental_card.dart';

class WeeklyScheduleTile extends StatelessWidget {
  const WeeklyScheduleTile({super.key, required this.subtitle, this.onTap});

  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ParentalCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            Icons.chevron_left_rounded,
            size: 22.sp,
            color: AppColors.textSecondary,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  LocaleKeys.profile_parental_weeklySchedule.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle.isEmpty
                      ? LocaleKeys.profile_parental_weeklyScheduleSubtitle.tr()
                      : subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primaryDark,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
