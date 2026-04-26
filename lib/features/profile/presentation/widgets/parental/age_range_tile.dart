import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/parental_card.dart';

class AgeRangeTile extends StatelessWidget {
  const AgeRangeTile({
    super.key,
    required this.from,
    required this.to,
    this.onTap,
  });

  final int from;
  final int to;
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
                  'profile.parental.ageRange'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'profile.parental.ageRangeValue'.tr(
                    namedArgs: {'from': from.toString(), 'to': to.toString()},
                  ),
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
              color: AppColors.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.access_time_rounded,
              color: AppColors.tertiary,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
