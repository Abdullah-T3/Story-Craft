import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';

class StoryHero extends StatelessWidget {
  const StoryHero({super.key, required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            story.coverColor,
            story.coverColor.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
      ),
      child: Column(
        children: [
          Container(
            width: 140.r,
            height: 140.r,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: (story.coverImageUrl != null &&
                    story.coverImageUrl!.isNotEmpty)
                ? Image.network(
                    story.coverImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Center(
                      child: Text(
                        story.coverEmoji,
                        style: TextStyle(fontSize: 72.sp),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      story.coverEmoji,
                      style: TextStyle(fontSize: 72.sp),
                    ),
                  ),
          ),
          SizedBox(height: 16.h),
          Text(
            story.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              _Chip(
                icon: Icons.access_time_rounded,
                label: LocaleKeys.story_duration.tr(
                  namedArgs: {'minutes': story.durationMinutes.toString()},
                ),
              ),
              _Chip(
                icon: Icons.cake_outlined,
                label: LocaleKeys.story_ageRange.tr(
                  namedArgs: {
                    'from': story.ageRangeFrom.toString(),
                    'to': story.ageRangeTo.toString(),
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.primaryDark),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
