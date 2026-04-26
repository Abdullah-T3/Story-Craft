import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/entities/saved_story.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';

class GetSavedStoriesUseCase
    implements UseCase<AppResult<List<SavedStory>>, SavedStoryListKind> {
  const GetSavedStoriesUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<AppResult<List<SavedStory>>> call(SavedStoryListKind params) =>
      _repository.getSavedStories(kind: params);
}
