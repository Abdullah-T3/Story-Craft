import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/core/widgets/inherited_or_new_bloc.dart';
import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';
import 'package:story_craft/features/profile/presentation/cubit/account/account_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/account/account_state.dart';
import 'package:story_craft/features/profile/presentation/widgets/account/avatar_badge.dart';
import 'package:story_craft/features/profile/presentation/widgets/account/profile_header_card.dart';
import 'package:story_craft/features/profile/presentation/widgets/account/settings_section.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/circle_icon_button.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/screen_header.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InheritedOrNewBloc<AccountCubit>(
      create: () => getIt<AccountCubit>()..load(),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocBuilder<AccountCubit, AccountState>(
            builder: (context, state) {
              return switch (state) {
                AccountInitial() || AccountLoading() => const AppLoading(),
                AccountError(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context.read<AccountCubit>().load(),
                ),
                AccountLoaded(:final profile) => _AccountBody(profile: profile),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _AccountBody extends StatelessWidget {
  const _AccountBody({required this.profile});

  final ReaderProfile profile;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryDark,
      onRefresh: () => context.read<AccountCubit>().load(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 120.h),
        child: Column(
          children: [
            ScreenHeader(
              title: LocaleKeys.profile_account_title.tr(),
              trailing: CircleIconButton(
                icon: Icons.settings_outlined,
                onTap: () {},
              ),
            ),
            SizedBox(height: 16.h),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: ProfileHeaderCard(profile: profile),
                ),
                Positioned(
                  top: 0,
                  child: AvatarBadge(
                    emoji: profile.avatarEmoji,
                    photoUrl: profile.photoUrl,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            const SettingsSection(),
          ],
        ),
      ),
    );
  }
}
