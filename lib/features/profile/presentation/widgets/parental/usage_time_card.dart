import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/parental_card.dart';

class UsageTimeCard extends StatelessWidget {
  const UsageTimeCard({super.key, required this.settings});

  final ParentalSettings settings;

  @override
  Widget build(BuildContext context) {
    return ParentalCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'profile.parental.todayQuota'.tr(
                  namedArgs: {
                    'used': settings.usedTodayMinutes.toString(),
                    'total': settings.dailyQuotaMinutes.toString(),
                  },
                ),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.tertiary,
                ),
              ),
              Text(
                'profile.parental.todayTime'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: settings.usageProgress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation(AppColors.tertiary),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'profile.parental.todayRemaining'.tr(
                  namedArgs: {
                    'minutes': settings.remainingMinutes.toString(),
                  },
                ),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'profile.parental.todayUsed'.tr(
                  namedArgs: {
                    'minutes': settings.usedTodayMinutes.toString(),
                  },
                ),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
