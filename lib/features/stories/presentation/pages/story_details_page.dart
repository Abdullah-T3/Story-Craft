import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/features/stories/presentation/cubit/story_details/story_details_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/story_details/story_details_state.dart';
import 'package:story_craft/features/stories/presentation/widgets/story_details/story_action_bar.dart';
import 'package:story_craft/features/stories/presentation/widgets/story_details/story_hero.dart';
import 'package:story_craft/features/stories/presentation/widgets/story_details/story_summary_section.dart';

class StoryDetailsPage extends StatelessWidget {
  const StoryDetailsPage({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoryDetailsCubit>()..load(storyId),
      child: const _DetailsView(),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocBuilder<StoryDetailsCubit, StoryDetailsState>(
            builder: (context, state) {
              if (state.isLoading || state.story == null) {
                if (state.error != null) {
                  return AppErrorView(
                    message: state.error,
                    onRetry: () => context
                        .read<StoryDetailsCubit>()
                        .load(state.story?.id ?? ''),
                  );
                }
                return const AppLoading();
              }
              final story = state.story!;
              return Column(
                children: [
                  _TopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          StoryHero(story: story),
                          StorySummarySection(summary: story.summary),
                        ],
                      ),
                    ),
                  ),
                  StoryActionBar(
                    isFavorite: state.isFavorite,
                    continueReading: state.hasInProgressReading,
                    onFavorite: () =>
                        context.read<StoryDetailsCubit>().toggleFavorite(),
                    onPrimary: () => context.pushNamed(
                      AppRoutes.storyReaderPath,
                      arguments: story.id,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.ios_share_rounded, size: 22.sp),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.chevron_left_rounded, size: 28.sp),
          ),
        ],
      ),
    );
  }
}
