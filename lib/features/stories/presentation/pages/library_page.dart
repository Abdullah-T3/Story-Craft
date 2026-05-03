import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/core/widgets/inherited_or_new_bloc.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_craft/features/stories/presentation/cubit/library/library_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/library/library_state.dart';
import 'package:story_craft/features/stories/presentation/widgets/library/category_chips.dart';
import 'package:story_craft/features/stories/presentation/widgets/library/library_greeting.dart';
import 'package:story_craft/features/stories/presentation/widgets/library/story_grid.dart';
import 'package:story_craft/features/stories/presentation/widgets/library/story_of_the_day_card.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InheritedOrNewBloc<LibraryCubit>(
      create: () => getIt<LibraryCubit>()..load(),
      child: const _LibraryView(),
    );
  }
}

class _LibraryView extends StatelessWidget {
  const _LibraryView();

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthRepository>().currentUser;
    final name = user?.displayName?.split(' ').first ?? 'صديقي';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocBuilder<LibraryCubit, LibraryState>(
            builder: (context, state) {
              if (state.isLoading && state.stories.isEmpty) {
                return const AppLoading();
              }
              if (state.error != null && state.stories.isEmpty) {
                return AppErrorView(
                  message: state.error,
                  onRetry: () => context.read<LibraryCubit>().load(),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<LibraryCubit>().load(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 120.h),
                  child: Column(
                    children: [
                      LibraryGreeting(
                        name: name,
                        onNotifications: () =>
                            context.pushNamed(AppRoutes.notificationsPath),
                        onSearch: () =>
                            context.pushNamed(AppRoutes.searchPath),
                      ),
                      SizedBox(height: 8.h),
                      if (state.featured != null)
                        StoryOfTheDayCard(
                          story: state.featured!,
                          onTap: () => context.pushNamed(
                            AppRoutes.storyDetailsPath,
                            arguments: state.featured!.id,
                          ),
                        ),
                      SizedBox(height: 16.h),
                      CategoryChips(
                        selectedId: state.selectedCategoryId,
                        onSelect: (id) =>
                            context.read<LibraryCubit>().selectCategory(id),
                      ),
                      SizedBox(height: 16.h),
                      if (state.stories.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(32.r),
                          child: Text(
                            LocaleKeys.library_empty.tr(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      else
                        StoryGrid(stories: state.stories),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
