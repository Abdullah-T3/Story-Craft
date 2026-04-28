import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/stories/presentation/cubit/create_story/create_story_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/create_story/create_story_state.dart';
import 'package:story_craft/features/stories/presentation/widgets/create/cover_picker.dart';
import 'package:story_craft/features/stories/presentation/widgets/create/gradient_circle.dart';
import 'package:story_craft/features/stories/presentation/widgets/create/section_title.dart';
import 'package:story_craft/features/stories/presentation/widgets/create/story_category_chips.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/screen_header.dart';

class StorySetupPage extends StatelessWidget {
  const StorySetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateStoryCubit>(),
      child: const _StorySetupView(),
    );
  }
}

class _StorySetupView extends StatefulWidget {
  const _StorySetupView();

  @override
  State<_StorySetupView> createState() => _StorySetupViewState();
}

class _StorySetupViewState extends State<_StorySetupView> {
  final TextEditingController _titleController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CreateStoryCubit>();
    _titleController.text = cubit.state.title;
    _titleController.addListener(() => cubit.setTitle(_titleController.text));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (picked == null) return;
    if (!mounted) return;
    await context.read<CreateStoryCubit>().uploadCoverImage(File(picked.path));
  }

  List<String> _localizedCategoryLabels() => [
    LocaleKeys.create_categories_adventures.tr(),
    LocaleKeys.create_categories_fantasy.tr(),
    LocaleKeys.create_categories_animals.tr(),
    LocaleKeys.create_categories_educational.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocConsumer<CreateStoryCubit, CreateStoryState>(
            listenWhen: (prev, curr) =>
                curr.error != null && prev.error != curr.error,
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: AppColors.secondary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              }
            },
            builder: (context, state) {
              final cubit = context.read<CreateStoryCubit>();
              final selectedGradient = LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: CreateStoryState.moodGradients[state.moodIndex],
              );
              return Column(
                children: [
                  ScreenHeader(title: LocaleKeys.create_setupTitle.tr()),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SectionTitle(LocaleKeys.create_cover.tr()),
                          SizedBox(height: 10.h),
                          CoverPicker(
                            imageUrl: state.coverImageUrl,
                            isUploading: state.isUploadingCover,
                            fallbackGradient: selectedGradient,
                            onPick: _pickCoverImage,
                            onRemove: cubit.clearCover,
                          ),
                          SizedBox(height: 22.h),
                          SectionTitle(LocaleKeys.create_title.tr()),
                          SizedBox(height: 10.h),
                          _TitleField(controller: _titleController),
                          SizedBox(height: 22.h),
                          SectionTitle(LocaleKeys.create_category.tr()),
                          SizedBox(height: 10.h),
                          StoryCategoryChips(
                            categories: _localizedCategoryLabels(),
                            selectedIndex: state.categoryIndex,
                            onSelected: cubit.selectCategory,
                          ),
                          SizedBox(height: 22.h),
                          SectionTitle(LocaleKeys.create_moodColor.tr()),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                              CreateStoryState.moodGradients.length,
                              (index) => GradientCircle(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: CreateStoryState.moodGradients[index],
                                ),
                                selected: index == state.moodIndex,
                                onTap: () => cubit.selectMood(index),
                              ),
                            ),
                          ),
                          SizedBox(height: 22.h),
                          SectionTitle(LocaleKeys.create_preview.tr()),
                          SizedBox(height: 10.h),
                          _PreviewCard(
                            title: state.title,
                            categoryLabel:
                                _localizedCategoryLabels()[state.categoryIndex],
                            gradient: selectedGradient,
                            imageUrl: state.coverImageUrl,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                    child: FilledButton(
                      onPressed: state.title.trim().isEmpty
                          ? null
                          : () => context.pushNamed(
                                AppRoutes.storyPagesEditorPath,
                                arguments: cubit,
                              ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.create_next.tr(),
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
}

class _TitleField extends StatelessWidget {
  const _TitleField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: LocaleKeys.create_titleHint.tr(),
        hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.title,
    required this.categoryLabel,
    required this.gradient,
    this.imageUrl,
  });

  final String title;
  final String categoryLabel;
  final Gradient gradient;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    return Container(
      height: 140.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: hasImage ? null : gradient,
        color: hasImage ? Colors.black : null,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            Image.network(imageUrl!, fit: BoxFit.cover),
          if (hasImage)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.45),
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(18.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.isEmpty
                      ? LocaleKeys.create_previewPlaceholder.tr()
                      : title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  categoryLabel,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
