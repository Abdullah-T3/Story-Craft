import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart';
import 'package:story_craft/features/stories/domain/usecases/search_stories_usecase.dart';
import 'package:story_craft/features/stories/presentation/cubit/search/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchStoriesUseCase searchStories,
    required SharedPrefsHelper prefs,
  }) : _searchStories = searchStories,
       _prefs = prefs,
       super(const SearchState());

  final SearchStoriesUseCase _searchStories;
  final SharedPrefsHelper _prefs;

  static const _recentKey = 'search_recent';
  static const _maxRecent = 8;

  Timer? _debounce;

  Future<void> loadRecent() async {
    final list =
        _prefs.getData<List<String>>(key: _recentKey) ?? const <String>[];
    emit(state.copyWith(recent: list));
  }

  void onQueryChanged(String value) {
    emit(state.copyWith(query: value, clearError: true));
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      emit(state.copyWith(results: const [], isLoading: false));
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () => _run(value));
  }

  Future<void> _run(String query) async {
    emit(state.copyWith(isLoading: true));
    final result = await _searchStories(query);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(state.copyWith(isLoading: false, results: list)),
    );
  }

  Future<void> commitToRecent(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final list = [trimmed, ...state.recent.where((q) => q != trimmed)];
    final trimmedList = list.take(_maxRecent).toList();
    await _prefs.storeData<List<String>>(key: _recentKey, value: trimmedList);
    emit(state.copyWith(recent: trimmedList));
  }

  Future<void> clearRecent() async {
    await _prefs.removeData(key: _recentKey);
    emit(state.copyWith(recent: const []));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
