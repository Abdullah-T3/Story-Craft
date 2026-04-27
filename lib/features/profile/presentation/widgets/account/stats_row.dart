import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.badges,
    required this.written,
    required this.printed,
  });

  final int badges;
  final int written;
  final int printed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            value: badges,
            label: LocaleKeys.profile_account_stats_badges.tr(),
            background: AppColors.tertiaryContainer,
            valueColor: AppColors.tertiary,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatTile(
            value: written,
            label: LocaleKeys.profile_account_stats_storiesWritten.tr(),
            background: AppColors.primaryContainer,
            valueColor: AppColors.primaryDark,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatTile(
            value: printed,
            label: LocaleKeys.profile_account_stats_storiesPrinted.tr(),
            background: AppColors.secondaryContainer,
            valueColor: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.background,
    required this.valueColor,
  });

  final int value;
  final String label;
  final Color background;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
