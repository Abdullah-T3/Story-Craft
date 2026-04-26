import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/profile/domain/entities/achievements_summary.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';
import 'package:story_craft/features/profile/domain/entities/saved_story.dart';

abstract interface class ProfileRepository {
  Future<AppResult<ReaderProfile>> getReaderProfile();

  Future<AppResult<AchievementsSummary>> getAchievements();

  Future<AppResult<List<SavedStory>>> getSavedStories({
    required SavedStoryListKind kind,
  });

  Future<AppResult<ParentalSettings>> getParentalSettings();

  Future<AppResult<ParentalSettings>> updateParentalSettings(
    ParentalSettings settings,
  );
}
