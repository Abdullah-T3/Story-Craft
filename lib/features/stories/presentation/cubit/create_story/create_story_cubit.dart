import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/services/cloudinary/cloudinary_service.dart';
import 'package:story_craft/features/stories/presentation/cubit/create_story/create_story_state.dart';
import 'package:story_craft/features/stories/domain/usecases/create_story_usecase.dart';

class CreateStoryCubit extends Cubit<CreateStoryState> {
  CreateStoryCubit({
    required CreateStoryUseCase createStory,
    required CloudinaryService cloudinary,
  }) : _createStory = createStory,
       _cloudinary = cloudinary,
       super(const CreateStoryState());

  final CreateStoryUseCase _createStory;
  final CloudinaryService _cloudinary;

  // ── Setup mutations ────────────────────────────────────────────────────────

  void setTitle(String value) => emit(state.copyWith(title: value));

  void selectCategory(int index) =>
      emit(state.copyWith(categoryIndex: index));

  void selectMood(int index) => emit(state.copyWith(moodIndex: index));

  void clearCover() => emit(state.copyWith(clearCoverImage: true));

  Future<void> uploadCoverImage(File file) async {
    if (state.isUploadingCover) return;
    emit(state.copyWith(isUploadingCover: true, clearError: true));
    try {
      final url = await _cloudinary.uploadImage(file);
      emit(state.copyWith(isUploadingCover: false, coverImageUrl: url));
    } on CloudinaryUploadException catch (e) {
      emit(state.copyWith(isUploadingCover: false, error: e.message));
    } catch (e) {
      emit(state.copyWith(isUploadingCover: false, error: 'تعذر رفع الصورة'));
    }
  }

  // ── Pages mutations ────────────────────────────────────────────────────────

  void addPage() {
    final pages = [...state.pages, ''];
    final imageUrls = [...state.pageImageUrls, null];
    emit(
      state.copyWith(
        pages: pages,
        pageImageUrls: imageUrls,
        activePageIndex: pages.length - 1,
      ),
    );
  }

  void removePage(int index) {
    if (state.pages.length <= 1) return;
    final pages = [...state.pages]..removeAt(index);
    final imageUrls = [...state.pageImageUrls]..removeAt(index);
    final newIndex = state.activePageIndex.clamp(0, pages.length - 1);
    emit(
      state.copyWith(
        pages: pages,
        pageImageUrls: imageUrls,
        activePageIndex: newIndex,
      ),
    );
  }

  void setPageText(int index, String text) {
    final pages = [...state.pages];
    if (index < 0 || index >= pages.length) return;
    pages[index] = text;
    emit(state.copyWith(pages: pages));
  }

  void clearPageImage(int index) {
    if (index < 0 || index >= state.pageImageUrls.length) return;
    final imageUrls = [...state.pageImageUrls];
    imageUrls[index] = null;
    emit(state.copyWith(pageImageUrls: imageUrls));
  }

  Future<void> uploadPageImage(int index, File file) async {
    if (state.uploadingPageIndex != null) return;
    if (index < 0 || index >= state.pageImageUrls.length) return;
    emit(state.copyWith(uploadingPageIndex: index, clearError: true));
    try {
      final url = await _cloudinary.uploadImage(file);
      final imageUrls = [...state.pageImageUrls];
      imageUrls[index] = url;
      emit(
        state.copyWith(
          pageImageUrls: imageUrls,
          clearUploadingPageIndex: true,
        ),
      );
    } on CloudinaryUploadException catch (e) {
      emit(
        state.copyWith(
          clearUploadingPageIndex: true,
          error: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          clearUploadingPageIndex: true,
          error: 'تعذر رفع الصورة',
        ),
      );
    }
  }

  void goToPage(int index) {
    if (index < 0 || index >= state.pages.length) return;
    emit(state.copyWith(activePageIndex: index));
  }

  void resetDraft() => emit(const CreateStoryState());

  // ── Persistence ────────────────────────────────────────────────────────────

  /// Estimated read time = ~30 seconds per page (rounded up to a minute).
  int _estimateMinutes(int pageCount) =>
      (pageCount / 2).ceil().clamp(1, 60);

  /// Pack ARGB into a single int — uses the stable int channel getters.
  // ignore: deprecated_member_use
  int _argb(Color c) =>
      (c.alpha << 24) | (c.red << 16) | (c.green << 8) | c.blue;

  Future<void> save() async {
    if (state.isSaving) return;
    emit(
      state.copyWith(
        isSaving: true,
        clearError: true,
        clearSavedStoryId: true,
      ),
    );
    final result = await _createStory(
      CreateStoryParams(
        title: state.title.trim(),
        summary: state.pages.first.trim(),
        categoryId: state.categoryId,
        coverColor: _argb(state.coverColor),
        coverEmoji: CreateStoryState.defaultCoverEmoji,
        coverImageUrl: state.coverImageUrl,
        pageImageUrls: state.pageImageUrls,
        ageRangeFrom: 5,
        ageRangeTo: 9,
        durationMinutes: _estimateMinutes(state.pages.length),
        pageTexts: state.pages,
        tags: const [],
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(isSaving: false, error: f.message)),
      (story) => emit(state.copyWith(isSaving: false, savedStoryId: story.id)),
    );
  }
}
