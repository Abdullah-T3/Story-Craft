import 'package:dio/dio.dart';
import 'package:story_craft/features/posts/data/models/post_dto.dart';

class PostsRemoteDataSource {
  PostsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<PostDto>> fetchPosts({int limit = 10}) async {
    final response = await _dio.get<List<dynamic>>('/posts');
    final data = response.data;
    if (data == null) {
      throw const FormatException('Empty posts response');
    }
    final list = data
        .map((e) => PostDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    if (list.length <= limit) return list;
    return list.take(limit).toList();
  }
}
