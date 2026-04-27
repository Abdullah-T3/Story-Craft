import 'package:story_craft/features/stories/domain/entities/reading_progress.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';

class StoryDetailsState {
  const StoryDetailsState({
    this.isLoading = false,
    this.story,
    this.isFavorite = false,
    this.progress,
    this.error,
  });

  final bool isLoading;
  final Story? story;
  final bool isFavorite;
  final ReadingProgress? progress;
  final String? error;

  bool get hasInProgressReading =>
      progress != null && !progress!.completed && progress!.lastPageIndex > 0;

  StoryDetailsState copyWith({
    bool? isLoading,
    Story? story,
    bool? isFavorite,
    ReadingProgress? progress,
    String? error,
    bool clearError = false,
    bool clearProgress = false,
  }) {
    return StoryDetailsState(
      isLoading: isLoading ?? this.isLoading,
      story: story ?? this.story,
      isFavorite: isFavorite ?? this.isFavorite,
      progress: clearProgress ? null : (progress ?? this.progress),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
