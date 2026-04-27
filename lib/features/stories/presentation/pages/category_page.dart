import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/features/stories/domain/category_catalog.dart';
import 'package:story_craft/features/stories/presentation/cubit/library/library_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/library/library_state.dart';
import 'package:story_craft/features/stories/presentation/widgets/library/story_grid.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final category = CategoryCatalog.byId(categoryId);
    return BlocProvider(
      create: (_) => getIt<LibraryCubit>()..selectCategory(categoryId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.headerBackground,
          appBar: AppBar(
            backgroundColor: AppColors.headerBackground,
            elevation: 0,
            centerTitle: true,
            title: Text(
              category.labelKey.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<LibraryCubit, LibraryState>(
              builder: (context, state) {
                if (state.isLoading && state.stories.isEmpty) {
                  return const AppLoading();
                }
                if (state.error != null && state.stories.isEmpty) {
                  return AppErrorView(
                    message: state.error,
                    onRetry: () =>
                        context.read<LibraryCubit>().selectCategory(categoryId),
                  );
                }
                if (state.stories.isEmpty) {
                  return Center(
                    child: Text(
                      LocaleKeys.library_empty.tr(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: StoryGrid(stories: state.stories),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
