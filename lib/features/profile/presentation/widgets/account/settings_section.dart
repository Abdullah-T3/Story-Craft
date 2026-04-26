import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/profile/presentation/widgets/account/settings_tile.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
            child: Text(
              LocaleKeys.profile_account_settings_section.tr(),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SettingsTile(
            icon: Icons.person_outline,
            iconColor: AppColors.primaryDark,
            iconBackground: AppColors.primaryContainer,
            title: LocaleKeys.profile_account_settings_personalInfo.tr(),
            subtitle:
                LocaleKeys.profile_account_settings_personalInfoSubtitle.tr(),
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.verified_user_outlined,
            iconColor: AppColors.secondary,
            iconBackground: AppColors.secondaryContainer,
            title: LocaleKeys.profile_account_settings_parental.tr(),
            subtitle: LocaleKeys.profile_account_settings_parentalSubtitle.tr(),
            onTap: () => context.pushNamed(AppRoutes.parentalControlPath),
          ),
          SettingsTile(
            icon: Icons.notifications_none_rounded,
            iconColor: AppColors.tertiary,
            iconBackground: AppColors.tertiaryContainer,
            title: LocaleKeys.profile_account_settings_notifications.tr(),
            subtitle:
                LocaleKeys.profile_account_settings_notificationsSubtitle.tr(),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
