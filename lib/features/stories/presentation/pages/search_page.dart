import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/stories/presentation/cubit/search/search_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/search/search_state.dart';
import 'package:story_craft/features/stories/presentation/widgets/library/story_card.dart';
import 'package:story_craft/features/stories/presentation/widgets/search/recent_searches.dart';
import 'package:story_craft/features/stories/presentation/widgets/search/search_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>()..loadRecent(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        appBar: AppBar(
          backgroundColor: AppColors.headerBackground,
          elevation: 0,
          centerTitle: true,
          title: Text(
            LocaleKeys.search_title.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              final cubit = context.read<SearchCubit>();
              return Column(
                children: [
                  SearchFieldBar(
                    controller: _controller,
                    onChanged: cubit.onQueryChanged,
                    onSubmitted: (q) => cubit.commitToRecent(q),
                  ),
                  if (state.query.trim().isEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            RecentSearches(
                              items: state.recent,
                              onTap: (q) {
                                _controller.text = q;
                                cubit.onQueryChanged(q);
                              },
                              onClear: cubit.clearRecent,
                            ),
                            if (state.recent.isEmpty)
                              Padding(
                                padding: EdgeInsets.all(32.r),
                                child: Text(
                                  LocaleKeys.search_startTyping.tr(),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(child: _Results(state: state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.results.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Text(
            LocaleKeys.search_empty.tr(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: state.results.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, i) {
        final story = state.results[i];
        return StoryCard(
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
