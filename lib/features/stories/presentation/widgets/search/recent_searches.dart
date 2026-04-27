import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({
    super.key,
    required this.items,
    required this.onTap,
    required this.onClear,
  });

  final List<String> items;
  final ValueChanged<String> onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onClear,
                child: Text(LocaleKeys.search_clearRecent.tr()),
              ),
              Text(
                LocaleKeys.search_recent.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8.w,
            runSpacing: 8.h,
            children: items
                .map(
                  (q) => ActionChip(
                    label: Text(q),
                    onPressed: () => onTap(q),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
