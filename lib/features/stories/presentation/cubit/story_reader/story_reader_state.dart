import 'package:story_craft/features/stories/domain/entities/story.dart';

class StoryReaderState {
  const StoryReaderState({
    this.isLoading = false,
    this.story,
    this.currentIndex = 0,
    this.completed = false,
    this.error,
  });

  final bool isLoading;
  final Story? story;
  final int currentIndex;
  final bool completed;
  final String? error;

  StoryReaderState copyWith({
    bool? isLoading,
    Story? story,
    int? currentIndex,
    bool? completed,
    String? error,
    bool clearError = false,
  }) {
    return StoryReaderState(
      isLoading: isLoading ?? this.isLoading,
      story: story ?? this.story,
      currentIndex: currentIndex ?? this.currentIndex,
      completed: completed ?? this.completed,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
