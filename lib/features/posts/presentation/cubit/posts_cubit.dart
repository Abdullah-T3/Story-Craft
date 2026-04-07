import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/features/posts/domain/repositories/posts_repository.dart';
import 'package:story_craft/features/posts/presentation/cubit/posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this._repository) : super(const PostsInitial());

  final PostsRepository _repository;

  Future<void> load() async {
    emit(const PostsLoading());
    final result = await _repository.getPosts();
    result.fold(
      (failure) => emit(PostsError(message: failure.message)),
      (posts) => emit(PostsLoaded(posts)),
    );
  }
}
