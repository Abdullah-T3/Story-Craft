import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/notifications/domain/entities/app_notification.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _palette(notification.kind);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : palette.background.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: palette.background,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(palette.icon, color: palette.foreground, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _typeLabel(notification.kind),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: palette.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(NotificationKind k) => switch (k) {
    NotificationKind.newStory => LocaleKeys.notifications_newStory.tr(),
    NotificationKind.reminder => LocaleKeys.notifications_reminder.tr(),
    NotificationKind.badge => LocaleKeys.notifications_badge.tr(),
  };

  ({Color background, Color foreground, IconData icon}) _palette(
    NotificationKind k,
  ) {
    return switch (k) {
      NotificationKind.newStory => (
        background: AppColors.primaryContainer,
        foreground: AppColors.primaryDark,
        icon: Icons.menu_book_rounded,
      ),
      NotificationKind.reminder => (
        background: AppColors.tertiaryContainer,
        foreground: AppColors.tertiary,
        icon: Icons.alarm_rounded,
      ),
      NotificationKind.badge => (
        background: AppColors.secondaryContainer,
        foreground: AppColors.secondary,
        icon: Icons.emoji_events_rounded,
      ),
    };
  }
}
