import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/stories/presentation/cubit/create_story/create_story_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/create_story/create_story_state.dart';
import 'package:story_craft/features/stories/presentation/widgets/create/editor_buttons.dart';
import 'package:story_craft/features/stories/presentation/widgets/create/page_navigation_bar.dart';
import 'package:story_craft/features/stories/presentation/widgets/create/story_page_card.dart';
import 'package:story_craft/features/stories/presentation/widgets/create/text_editor_toolbar.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/screen_header.dart';

class StoryPagesEditorScreen extends StatelessWidget {
  const StoryPagesEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ModalRoute.of(context)?.settings.arguments;
    if (cubit is CreateStoryCubit) {
      return BlocProvider.value(value: cubit, child: const _EditorView());
    }
    // Fallback: started directly without going through setup.
    return BlocProvider(
      create: (_) => throw StateError(
        'StoryPagesEditorScreen requires a CreateStoryCubit argument',
      ),
      child: const _EditorView(),
    );
  }
}

class _EditorView extends StatefulWidget {
  const _EditorView();

  @override
  State<_EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<_EditorView> {
  final PageController _pageController = PageController();
  final ImagePicker _picker = ImagePicker();
  bool _showToolbar = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickPageImage(int index) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (picked == null) return;
    if (!mounted) return;
    await context
        .read<CreateStoryCubit>()
        .uploadPageImage(index, File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocConsumer<CreateStoryCubit, CreateStoryState>(
            listenWhen: (prev, curr) =>
                prev.activePageIndex != curr.activePageIndex ||
                (curr.savedStoryId != null &&
                    prev.savedStoryId != curr.savedStoryId) ||
                (curr.error != null && prev.error != curr.error),
            listener: (context, state) {
              if (_pageController.hasClients &&
                  _pageController.page?.round() != state.activePageIndex) {
                _pageController.animateToPage(
                  state.activePageIndex,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                );
              }
              if (state.savedStoryId != null) {
                _showSavedDialog(context, state.savedStoryId!);
              } else if (state.error != null) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: AppColors.secondary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 6),
                    ),
                  );
              }
            },
            builder: (context, state) {
              final cubit = context.read<CreateStoryCubit>();
              return Column(
                children: [
                  ScreenHeader(title: LocaleKeys.create_editorTitle.tr()),
                  PageNavigationBar(
                    currentPage: state.activePageIndex + 1,
                    pageCount: state.pages.length,
                    onPrevious: () =>
                        cubit.goToPage(state.activePageIndex - 1),
                    onNext: () => cubit.goToPage(state.activePageIndex + 1),
                    label: LocaleKeys.create_pageOf.tr(
                      namedArgs: {
                        'current': (state.activePageIndex + 1).toString(),
                        'total': state.pages.length.toString(),
                      },
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.pages.length,
                      onPageChanged: cubit.goToPage,
                      itemBuilder: (_, i) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: StoryPageCard(
                          key: ValueKey(i),
                          text: state.pages[i],
                          imageUrl: i < state.pageImageUrls.length
                              ? state.pageImageUrls[i]
                              : null,
                          coverColor: state.coverColor,
                          coverEmoji: CreateStoryState.defaultCoverEmoji,
                          isUploading: state.uploadingPageIndex == i,
                          onPickImage: () => _pickPageImage(i),
                          onRemoveImage: () => cubit.clearPageImage(i),
                          onChanged: (v) => cubit.setPageText(i, v),
                          onRemovePage: () => cubit.removePage(i),
                          canRemovePage: state.pages.length > 1,
                        ),
                      ),
                    ),
                  ),
                  if (_showToolbar)
                    TextEditorToolbar(
                      onBold: () {},
                      onAlignLeft: () {},
                      onAlignCenter: () {},
                      onAlignRight: () {},
                      onColor: () {},
                    ),
                  EditorButtons(
                    onAddPage: cubit.addPage,
                    onEditText: () =>
                        setState(() => _showToolbar = !_showToolbar),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                    child: FilledButton(
                      onPressed: state.isSaving ? null : cubit.save,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                      child: state.isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              LocaleKeys.create_save.tr(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
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

  void _showSavedDialog(BuildContext context, String storyId) {
    final navigator = Navigator.of(context, rootNavigator: true);
    Future.microtask(() {
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: Icon(
              Icons.celebration_rounded,
              size: 40,
              color: AppColors.tertiary,
            ),
            title: Text(LocaleKeys.create_savedTitle.tr()),
            content: Text(LocaleKeys.create_savedBody.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  navigator.popUntil(
                    (r) =>
                        r.settings.name == AppRoutes.mainLayoutPath ||
                        r.isFirst,
                  );
                },
                child: Text(LocaleKeys.create_backToLibrary.tr()),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  navigator.popUntil(
                    (r) =>
                        r.settings.name == AppRoutes.mainLayoutPath ||
                        r.isFirst,
                  );
                  navigator.pushNamed(
                    AppRoutes.storyDetailsPath,
                    arguments: storyId,
                  );
                },
                child: Text(LocaleKeys.create_open.tr()),
              ),
            ],
          ),
        ),
      );
    });
  }
}
