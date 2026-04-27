import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class ReaderTopBar extends StatelessWidget {
  const ReaderTopBar({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.onClose,
  });

  final int currentIndex;
  final int total;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close_rounded, size: 24.sp),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  LocaleKeys.story_pageOf.tr(
                    namedArgs: {
                      'current': (currentIndex + 1).toString(),
                      'total': total.toString(),
                    },
                  ),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 40.r),
        ],
      ),
    );
  }
}
