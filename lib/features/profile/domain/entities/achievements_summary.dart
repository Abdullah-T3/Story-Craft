import 'package:story_craft/features/profile/domain/entities/badge.dart';

class AchievementsSummary {
  const AchievementsSummary({
    required this.levelKey,
    required this.badges,
    required this.streakDays,
    required this.streakWeek,
  });

  final String levelKey;
  final List<AchievementBadge> badges;
  final int streakDays;
  final List<bool> streakWeek;

  int get unlockedCount => badges.where((b) => b.unlocked).length;
  int get totalCount => badges.length;
}
