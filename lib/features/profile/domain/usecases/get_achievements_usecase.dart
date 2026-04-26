import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/entities/achievements_summary.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';

class GetAchievementsUseCase
    implements UseCase<AppResult<AchievementsSummary>, NoParams> {
  const GetAchievementsUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<AppResult<AchievementsSummary>> call(NoParams params) =>
      _repository.getAchievements();
}
