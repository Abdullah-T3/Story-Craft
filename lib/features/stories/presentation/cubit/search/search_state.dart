import 'package:story_craft/features/stories/domain/entities/story.dart';

class SearchState {
  const SearchState({
    this.query = '',
    this.results = const [],
    this.recent = const [],
    this.isLoading = false,
    this.error,
  });

  final String query;
  final List<Story> results;
  final List<String> recent;
  final bool isLoading;
  final String? error;

  SearchState copyWith({
    String? query,
    List<Story>? results,
    List<String>? recent,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      recent: recent ?? this.recent,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
