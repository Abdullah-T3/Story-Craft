import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/features/profile/domain/entities/achievements_summary.dart';
import 'package:story_craft/features/profile/presentation/cubit/achievements/achievements_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/achievements/achievements_state.dart';
import 'package:story_craft/features/profile/presentation/widgets/achievements/badges_grid.dart';
import 'package:story_craft/features/profile/presentation/widgets/achievements/current_level_banner.dart';
import 'package:story_craft/features/profile/presentation/widgets/achievements/streak_strip.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/circle_icon_button.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/screen_header.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AchievementsCubit>()..load(),
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatelessWidget {
  const _AchievementsView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocBuilder<AchievementsCubit, AchievementsState>(
            builder: (context, state) {
              return switch (state) {
                AchievementsInitial() ||
                AchievementsLoading() => const AppLoading(),
                AchievementsErrorState(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context.read<AchievementsCubit>().load(),
                ),
                AchievementsLoaded(:final summary) => _AchievementsBody(
                  summary: summary,
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _AchievementsBody extends StatelessWidget {
  const _AchievementsBody({required this.summary});

  final AchievementsSummary summary;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Column(
        children: [
          ScreenHeader(
            title: 'profile.achievements.title'.tr(),
            trailing: CircleIconButton(
              icon: Icons.ios_share_rounded,
              onTap: () {},
            ),
          ),
          SizedBox(height: 8.h),
          CurrentLevelBanner(levelKey: summary.levelKey),
          SizedBox(height: 24.h),
          BadgesGrid(
            badges: summary.badges,
            unlocked: summary.unlockedCount,
            total: summary.totalCount,
          ),
          SizedBox(height: 24.h),
          StreakStrip(days: summary.streakDays, week: summary.streakWeek),
        ],
      ),
    );
  }
}
