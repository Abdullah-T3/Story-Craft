import 'package:story_craft/features/posts/domain/entities/post.dart';

sealed class PostsState {
  const PostsState();
}

final class PostsInitial extends PostsState {
  const PostsInitial();
}

final class PostsLoading extends PostsState {
  const PostsLoading();
}

final class PostsLoaded extends PostsState {
  const PostsLoaded(this.posts);

  final List<Post> posts;
}

final class PostsError extends PostsState {
  const PostsError({required this.message});

  final String message;
}
