import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/features/profile/domain/entities/saved_story.dart';
import 'package:story_craft/features/profile/domain/usecases/get_saved_stories_usecase.dart';
import 'package:story_craft/features/profile/presentation/cubit/saved_stories/saved_stories_state.dart';

class SavedStoriesCubit extends Cubit<SavedStoriesState> {
  SavedStoriesCubit(this._getSavedStories) : super(const SavedStoriesState());

  final GetSavedStoriesUseCase _getSavedStories;

  Future<void> load(SavedStoryListKind kind) async {
    emit(state.copyWith(activeTab: kind, isLoading: true, clearError: true));
    final result = await _getSavedStories(kind);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(state.copyWith(isLoading: false, stories: list)),
    );
  }
}
