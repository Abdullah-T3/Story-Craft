import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';

class ToggleFavoriteUseCase implements UseCase<AppResult<bool>, String> {
  const ToggleFavoriteUseCase(this._repo);
  final StoriesRepository _repo;

  @override
  Future<AppResult<bool>> call(String storyId) => _repo.toggleFavorite(storyId);
}
