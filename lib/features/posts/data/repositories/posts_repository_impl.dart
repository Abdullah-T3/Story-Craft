import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/posts/domain/entities/post.dart';
import 'package:story_craft/features/posts/domain/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  const PostsRepositoryImpl();

  @override
  Future<AppResult<List<Post>>> getPosts() async {
    // Temporary local data until Firebase data source is integrated.
    return right(const [
      Post(id: 1, title: 'Welcome to Story Craft'),
      Post(id: 2, title: 'Firebase integration coming soon'),
    ]);
  }
}
