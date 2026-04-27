import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/domain/services/parental_guard.dart';
import 'package:story_craft/features/profile/domain/usecases/get_parental_settings_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/get_stories_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/get_story_of_the_day_usecase.dart';
import 'package:story_craft/features/stories/presentation/cubit/library/library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit({
    required GetStoriesUseCase getStories,
    required GetStoryOfTheDayUseCase getStoryOfTheDay,
    required GetParentalSettingsUseCase getParental,
  }) : _getStories = getStories,
       _getStoryOfTheDay = getStoryOfTheDay,
       _getParental = getParental,
       super(const LibraryState());

  final GetStoriesUseCase _getStories;
  final GetStoryOfTheDayUseCase _getStoryOfTheDay;
  final GetParentalSettingsUseCase _getParental;

  ParentalSettings? _parental;

  Future<void> _ensureParental() async {
    if (_parental != null) return;
    final result = await _getParental(const NoParams());
    _parental = result.getRight().toNullable();
  }

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await _ensureParental();
    final featuredResult = await _getStoryOfTheDay(const NoParams());
    final storiesResult = await _getStories(state.selectedCategoryId);

    final newFeatured = featuredResult.fold((_) => state.featured, (s) => s);
    storiesResult.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(
        state.copyWith(
          isLoading: false,
          featured: newFeatured,
          stories: ParentalGuard.filter(list, _parental),
        ),
      ),
    );
  }

  Future<void> selectCategory(String categoryId) async {
    if (state.selectedCategoryId == categoryId) return;
    emit(
      state.copyWith(
        selectedCategoryId: categoryId,
        isLoading: true,
        clearError: true,
      ),
    );
    await _ensureParental();
    final result = await _getStories(categoryId);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(
        state.copyWith(
          isLoading: false,
          stories: ParentalGuard.filter(list, _parental),
        ),
      ),
    );
  }
}
