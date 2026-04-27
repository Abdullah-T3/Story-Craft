import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';

class GetStoryByIdUseCase implements UseCase<AppResult<Story>, String> {
  const GetStoryByIdUseCase(this._repo);
  final StoriesRepository _repo;

  @override
  Future<AppResult<Story>> call(String params) => _repo.getStoryById(params);
}
