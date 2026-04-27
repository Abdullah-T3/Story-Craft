import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';

abstract final class ParentalGuard {
  ParentalGuard._();

  /// Filter a list of stories by the parental age range and content filter.
  /// Stories tagged with "scary" or "violent" are removed when the
  /// content filter is enabled.
  static List<Story> filter(List<Story> stories, ParentalSettings? settings) {
    if (settings == null) return stories;
    return stories.where((s) {
      if (!s.fitsAge(settings.ageRangeFrom, settings.ageRangeTo)) return false;
      if (settings.contentFilterEnabled &&
          (s.tags.contains('scary') || s.tags.contains('violent'))) {
        return false;
      }
      return true;
    }).toList();
  }

  static bool hasTimeLeft(ParentalSettings? settings) {
    if (settings == null) return true;
    return settings.usedTodayMinutes < settings.dailyQuotaMinutes;
  }
}
