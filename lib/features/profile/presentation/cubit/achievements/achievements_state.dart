import 'package:story_craft/features/profile/domain/entities/achievements_summary.dart';

sealed class AchievementsState {
  const AchievementsState();
}

class AchievementsInitial extends AchievementsState {
  const AchievementsInitial();
}

class AchievementsLoading extends AchievementsState {
  const AchievementsLoading();
}

class AchievementsLoaded extends AchievementsState {
  const AchievementsLoaded(this.summary);
  final AchievementsSummary summary;
}

class AchievementsErrorState extends AchievementsState {
  const AchievementsErrorState(this.message);
  final String message;
}
