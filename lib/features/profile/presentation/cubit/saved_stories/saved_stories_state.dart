import 'package:story_craft/features/profile/domain/entities/saved_story.dart';

class SavedStoriesState {
  const SavedStoriesState({
    this.activeTab = SavedStoryListKind.favorites,
    this.isLoading = false,
    this.stories = const [],
    this.error,
  });

  final SavedStoryListKind activeTab;
  final bool isLoading;
  final List<SavedStory> stories;
  final String? error;

  SavedStoriesState copyWith({
    SavedStoryListKind? activeTab,
    bool? isLoading,
    List<SavedStory>? stories,
    String? error,
    bool clearError = false,
  }) {
    return SavedStoriesState(
      activeTab: activeTab ?? this.activeTab,
      isLoading: isLoading ?? this.isLoading,
      stories: stories ?? this.stories,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
