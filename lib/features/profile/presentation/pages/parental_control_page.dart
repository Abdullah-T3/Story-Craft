import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/presentation/cubit/parental/parental_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/parental/parental_state.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/age_range_tile.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/content_filter_tile.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/protection_banner.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/section_header.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/usage_time_card.dart';
import 'package:story_craft/features/profile/presentation/widgets/parental/weekly_schedule_tile.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/screen_header.dart';

class ParentalControlPage extends StatelessWidget {
  const ParentalControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ParentalCubit>()..load(),
      child: const _ParentalView(),
    );
  }
}

class _ParentalView extends StatelessWidget {
  const _ParentalView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocConsumer<ParentalCubit, ParentalState>(
            listenWhen: (prev, curr) => curr.error != null && prev.error != curr.error,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            },
            builder: (context, state) {
              if (state.isLoading && state.settings == null) {
                return const AppLoading();
              }
              if (state.settings == null) {
                return AppErrorView(
                  message: state.error,
                  onRetry: () => context.read<ParentalCubit>().load(),
                );
              }
              return _ParentalBody(settings: state.settings!);
            },
          ),
        ),
      ),
    );
  }
}

class _ParentalBody extends StatelessWidget {
  const _ParentalBody({required this.settings});

  final ParentalSettings settings;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Column(
        children: [
          ScreenHeader(title: LocaleKeys.profile_parental_title.tr()),
          SizedBox(height: 8.h),
          const ProtectionBanner(),
          ParentalSectionHeader(
            title: LocaleKeys.profile_parental_allowedContent.tr(),
          ),
          AgeRangeTile(from: settings.ageRangeFrom, to: settings.ageRangeTo),
          ContentFilterTile(
            enabled: settings.contentFilterEnabled,
            onChanged: (v) =>
                context.read<ParentalCubit>().setContentFilter(enabled: v),
          ),
          ParentalSectionHeader(
            title: LocaleKeys.profile_parental_usageTime.tr(),
          ),
          UsageTimeCard(settings: settings),
          WeeklyScheduleTile(subtitle: settings.weeklyScheduleSubtitle),
        ],
      ),
    );
  }
}
