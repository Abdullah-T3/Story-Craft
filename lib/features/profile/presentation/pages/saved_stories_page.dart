import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/inherited_or_new_bloc.dart';
import 'package:story_craft/features/profile/domain/entities/saved_story.dart';
import 'package:story_craft/features/profile/presentation/cubit/saved_stories/saved_stories_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/saved_stories/saved_stories_state.dart';
import 'package:story_craft/features/profile/presentation/widgets/saved/saved_story_card.dart';
import 'package:story_craft/features/profile/presentation/widgets/saved/saved_tabs_header.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/circle_icon_button.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/screen_header.dart';

class SavedStoriesPage extends StatelessWidget {
  const SavedStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InheritedOrNewBloc<SavedStoriesCubit>(
      create: () =>
          getIt<SavedStoriesCubit>()..load(SavedStoryListKind.favorites),
      child: const _SavedStoriesView(),
    );
  }
}

class _SavedStoriesView extends StatelessWidget {
  const _SavedStoriesView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocBuilder<SavedStoriesCubit, SavedStoriesState>(
            builder: (context, state) {
              return Column(
                children: [
                  ScreenHeader(
                    title: LocaleKeys.profile_saved_title.tr(),
                    trailing: CircleIconButton(
                      icon: Icons.search_rounded,
                      onTap: () {},
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SavedTabsHeader(
                    active: state.activeTab,
                    onChanged: (kind) =>
                        context.read<SavedStoriesCubit>().load(kind),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(child: _SavedList(state: state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SavedList extends StatelessWidget {
  const _SavedList({required this.state});

  final SavedStoriesState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.stories.isEmpty) {
      final key = state.activeTab == SavedStoryListKind.favorites
          ? LocaleKeys.profile_saved_emptyFavorites
          : LocaleKeys.profile_saved_emptyHistory;
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Text(
            key.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: state.stories.length,
      itemBuilder: (_, i) {
        final story = state.stories[i];
        return SavedStoryCard(
          story: story,
          onTap: () => context.pushNamed(
            AppRoutes.storyDetailsPath,
            arguments: story.id,
          ),
        );
      },
    );
  }
}
