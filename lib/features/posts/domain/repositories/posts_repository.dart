import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/posts/domain/entities/post.dart';

abstract interface class PostsRepository {
  Future<AppResult<List<Post>>> getPosts();
}
