import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';

class GetStoryOfTheDayUseCase
    implements UseCase<AppResult<Story>, NoParams> {
  const GetStoryOfTheDayUseCase(this._repo);
  final StoriesRepository _repo;

  @override
  Future<AppResult<Story>> call(NoParams params) => _repo.getStoryOfTheDay();
}
