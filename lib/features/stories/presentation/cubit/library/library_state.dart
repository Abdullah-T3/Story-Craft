import 'package:story_craft/features/stories/domain/entities/story.dart';

class LibraryState {
  const LibraryState({
    this.selectedCategoryId = 'all',
    this.featured,
    this.stories = const [],
    this.isLoading = false,
    this.error,
  });

  final String selectedCategoryId;
  final Story? featured;
  final List<Story> stories;
  final bool isLoading;
  final String? error;

  LibraryState copyWith({
    String? selectedCategoryId,
    Story? featured,
    List<Story>? stories,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return LibraryState(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      featured: featured ?? this.featured,
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
