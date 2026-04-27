import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';
import 'package:story_craft/features/stories/domain/usecases/get_story_by_id_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/toggle_favorite_usecase.dart';
import 'package:story_craft/features/stories/presentation/cubit/story_details/story_details_state.dart';

class StoryDetailsCubit extends Cubit<StoryDetailsState> {
  StoryDetailsCubit({
    required GetStoryByIdUseCase getStoryById,
    required ToggleFavoriteUseCase toggleFavorite,
    required StoriesRepository repository,
  }) : _getStoryById = getStoryById,
       _toggleFavorite = toggleFavorite,
       _repository = repository,
       super(const StoryDetailsState());

  final GetStoryByIdUseCase _getStoryById;
  final ToggleFavoriteUseCase _toggleFavorite;
  final StoriesRepository _repository;

  Future<void> load(String storyId) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final storyResult = await _getStoryById(storyId);
    await storyResult.fold(
      (f) async => emit(state.copyWith(isLoading: false, error: f.message)),
      (story) async {
        final favIds = await _repository.getFavoriteIds();
        final progress = await _repository.getProgress(storyId);
        emit(
          state.copyWith(
            isLoading: false,
            story: story,
            isFavorite: favIds
                .getRight()
                .toNullable()!
                .contains(storyId),
            progress: progress.getRight().toNullable(),
          ),
        );
      },
    );
  }

  Future<void> toggleFavorite() async {
    final story = state.story;
    if (story == null) return;
    final wasFav = state.isFavorite;
    emit(state.copyWith(isFavorite: !wasFav));
    final result = await _toggleFavorite(story.id);
    result.fold(
      (f) => emit(state.copyWith(isFavorite: wasFav, error: f.message)),
      (isFav) => emit(state.copyWith(isFavorite: isFav)),
    );
  }
}
