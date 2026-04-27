import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';

class GetStoriesUseCase implements UseCase<AppResult<List<Story>>, String?> {
  const GetStoriesUseCase(this._repo);
  final StoriesRepository _repo;

  @override
  Future<AppResult<List<Story>>> call(String? categoryId) =>
      _repo.getStories(categoryId: categoryId);
}
