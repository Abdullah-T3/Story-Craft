import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/features/profile/domain/entities/reader_stats.dart';

/// Maps reader activity to a friendly level shown on the achievements banner.
abstract final class LevelRules {
  LevelRules._();

  // Thresholds (stories completed) — tune in one place.
  static const int curiousAt = 1;
  static const int skilledAt = 5;
  static const int voraciousAt = 10;
  static const int championAt = 25;

  static String resolveKey(ReaderStats stats) {
    final completed = stats.storiesRead;
    if (completed >= championAt) {
      return LocaleKeys.profile_achievements_levelChampion;
    }
    if (completed >= voraciousAt) {
      return LocaleKeys.profile_achievements_levelVoracious;
    }
    if (completed >= skilledAt) {
      return LocaleKeys.profile_achievements_levelSkilledReader;
    }
    if (completed >= curiousAt) {
      return LocaleKeys.profile_achievements_levelCurious;
    }
    return LocaleKeys.profile_achievements_levelBeginner;
  }
}
