import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/stories/domain/entities/reading_progress.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';

abstract interface class StoriesRepository {
  Future<AppResult<List<Story>>> getStories({String? categoryId});

  Future<AppResult<Story>> getStoryById(String id);

  Future<AppResult<Story>> getStoryOfTheDay();

  Future<AppResult<List<Story>>> searchStories(String query);

  Future<AppResult<List<Story>>> getStoriesByIds(List<String> ids);

  Future<AppResult<List<String>>> getFavoriteIds();

  Future<AppResult<bool>> toggleFavorite(String storyId);

  Future<AppResult<ReadingProgress?>> getProgress(String storyId);

  Future<AppResult<void>> saveProgress({
    required String storyId,
    required int lastPageIndex,
    required int totalPages,
    required bool completed,
  });

  Future<AppResult<List<ReadingProgress>>> getHistory();
}
