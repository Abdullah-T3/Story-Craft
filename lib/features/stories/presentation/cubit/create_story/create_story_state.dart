import 'package:flutter/material.dart';

class CreateStoryState {
  const CreateStoryState({
    this.title = '',
    this.categoryIndex = 0,
    this.moodIndex = 0,
    this.coverImageUrl,
    this.pages = const [''],
    this.pageImageUrls = const [null],
    this.activePageIndex = 0,
    this.isUploadingCover = false,
    this.uploadingPageIndex,
    this.isSaving = false,
    this.savedStoryId,
    this.error,
  });

  final String title;
  final int categoryIndex;
  final int moodIndex;
  final String? coverImageUrl;
  final List<String> pages;
  final List<String?> pageImageUrls;
  final int activePageIndex;
  final bool isUploadingCover;
  final int? uploadingPageIndex;
  final bool isSaving;
  final String? savedStoryId;
  final String? error;

  bool get hasCover => coverImageUrl != null && coverImageUrl!.isNotEmpty;

  // Static palette of mood gradients used by setup + editor.
  static const List<List<Color>> moodGradients = [
    [Color(0xFF8BE4B6), Color(0xFF4F6B5F)],
    [Color(0xFF8CC4FF), Color(0xFFB39DFF)],
    [Color(0xFFFFB3B3), Color(0xFFFFD6A5)],
    [Color(0xFFE0F7FA), Color(0xFF00838F)],
  ];

  /// Stable categoryId list — must match `CategoryCatalog`.
  static const List<String> categoryIds = [
    'adventures',
    'fantasy',
    'animals',
    'educational',
  ];

  static const String defaultCoverEmoji = '📖';

  Color get coverColor => moodGradients[moodIndex].first;
  String get categoryId => categoryIds[categoryIndex];

  CreateStoryState copyWith({
    String? title,
    int? categoryIndex,
    int? moodIndex,
    String? coverImageUrl,
    List<String>? pages,
    List<String?>? pageImageUrls,
    int? activePageIndex,
    bool? isUploadingCover,
    int? uploadingPageIndex,
    bool? isSaving,
    String? savedStoryId,
    String? error,
    bool clearError = false,
    bool clearSavedStoryId = false,
    bool clearCoverImage = false,
    bool clearUploadingPageIndex = false,
  }) {
    return CreateStoryState(
      title: title ?? this.title,
      categoryIndex: categoryIndex ?? this.categoryIndex,
      moodIndex: moodIndex ?? this.moodIndex,
      coverImageUrl:
          clearCoverImage ? null : (coverImageUrl ?? this.coverImageUrl),
      pages: pages ?? this.pages,
      pageImageUrls: pageImageUrls ?? this.pageImageUrls,
      activePageIndex: activePageIndex ?? this.activePageIndex,
      isUploadingCover: isUploadingCover ?? this.isUploadingCover,
      uploadingPageIndex: clearUploadingPageIndex
          ? null
          : (uploadingPageIndex ?? this.uploadingPageIndex),
      isSaving: isSaving ?? this.isSaving,
      savedStoryId:
          clearSavedStoryId ? null : (savedStoryId ?? this.savedStoryId),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
