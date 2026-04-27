import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class StoryActionBar extends StatelessWidget {
  const StoryActionBar({
    super.key,
    required this.isFavorite,
    required this.continueReading,
    required this.onPrimary,
    required this.onFavorite,
  });

  final bool isFavorite;
  final bool continueReading;
  final VoidCallback onPrimary;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        child: Row(
          children: [
            InkWell(
              onTap: onFavorite,
              borderRadius: BorderRadius.circular(28.r),
              child: Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.secondary,
                  size: 26.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: FilledButton(
                onPressed: onPrimary,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Text(
                  continueReading
                      ? LocaleKeys.library_continueReading.tr()
                      : LocaleKeys.library_startReading.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
