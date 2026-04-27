import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';

class SaveProgressParams {
  const SaveProgressParams({
    required this.storyId,
    required this.lastPageIndex,
    required this.totalPages,
    required this.completed,
  });

  final String storyId;
  final int lastPageIndex;
  final int totalPages;
  final bool completed;
}

class SaveProgressUseCase
    implements UseCase<AppResult<void>, SaveProgressParams> {
  const SaveProgressUseCase(this._repo);
  final StoriesRepository _repo;

  @override
  Future<AppResult<void>> call(SaveProgressParams params) => _repo.saveProgress(
    storyId: params.storyId,
    lastPageIndex: params.lastPageIndex,
    totalPages: params.totalPages,
    completed: params.completed,
  );
}
