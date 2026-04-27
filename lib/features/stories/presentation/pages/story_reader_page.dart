import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/features/stories/presentation/cubit/story_reader/story_reader_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/story_reader/story_reader_state.dart';
import 'package:story_craft/features/stories/presentation/widgets/story_reader/reader_bottom_bar.dart';
import 'package:story_craft/features/stories/presentation/widgets/story_reader/reader_page_view.dart';
import 'package:story_craft/features/stories/presentation/widgets/story_reader/reader_top_bar.dart';

class StoryReaderPage extends StatelessWidget {
  const StoryReaderPage({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoryReaderCubit>()..load(storyId),
      child: const _ReaderView(),
    );
  }
}

class _ReaderView extends StatefulWidget {
  const _ReaderView();

  @override
  State<_ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<_ReaderView> {
  final PageController _controller = PageController();
  bool _quotaShown = false;

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
        body: SafeArea(
          child: BlocConsumer<StoryReaderCubit, StoryReaderState>(
            listener: (context, state) {
              if (state.story != null &&
                  context.read<StoryReaderCubit>().isOverDailyQuota() &&
                  !_quotaShown) {
                _quotaShown = true;
                _showQuotaDialog(context);
              }
              if (state.completed) {
                _showFinishDialog(context);
              }
              if (state.story != null &&
                  _controller.hasClients &&
                  _controller.page?.round() != state.currentIndex) {
                _controller.animateToPage(
                  state.currentIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            builder: (context, state) {
              if (state.isLoading || state.story == null) {
                if (state.error != null) {
                  return AppErrorView(
                    message: state.error,
                    onRetry: () =>
                        context.read<StoryReaderCubit>().load(state.story!.id),
                  );
                }
                return const AppLoading();
              }
              final story = state.story!;
              return Column(
                children: [
                  ReaderTopBar(
                    currentIndex: state.currentIndex,
                    total: story.pageCount,
                    onClose: () => context.pop(),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: story.pageCount,
                      onPageChanged: (i) =>
                          context.read<StoryReaderCubit>().goToPage(i),
                      itemBuilder: (_, i) =>
                          ReaderPageView(page: story.pages[i]),
                    ),
                  ),
                  ReaderBottomBar(
                    currentIndex: state.currentIndex,
                    total: story.pageCount,
                    onPrevious: () => context
                        .read<StoryReaderCubit>()
                        .goToPage(state.currentIndex - 1),
                    onNext: () => context
                        .read<StoryReaderCubit>()
                        .goToPage(state.currentIndex + 1),
                    onFinish: () =>
                        context.read<StoryReaderCubit>().markFinished(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFinishDialog(BuildContext context) {
    Future.microtask(() {
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(LocaleKeys.story_finishTitle.tr()),
            content: Text(LocaleKeys.story_finishBody.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: Text(LocaleKeys.story_backToLibrary.tr()),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<StoryReaderCubit>().goToPage(0);
                },
                child: Text(LocaleKeys.story_readAgain.tr()),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showQuotaDialog(BuildContext context) {
    Future.microtask(() {
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: Icon(
              Icons.timer_off_rounded,
              size: 40.sp,
              color: AppColors.secondary,
            ),
            title: Text(LocaleKeys.story_timeUpTitle.tr()),
            content: Text(LocaleKeys.story_timeUpBody.tr()),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: Text(LocaleKeys.common_ok.tr()),
              ),
            ],
          ),
        ),
      );
    });
  }
}
