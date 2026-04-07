import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/network/dio_error_mapper.dart';
import 'package:story_craft/core/network/network_info.dart';
import 'package:story_craft/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:story_craft/features/posts/domain/entities/post.dart';
import 'package:story_craft/features/posts/domain/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl(this._remote, this._networkInfo);

  final PostsRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<AppResult<List<Post>>> getPosts() async {
    try {
      if (!await _networkInfo.isConnected) {
        return left(const NetworkFailure(message: 'No internet connection'));
      }
      final dtos = await _remote.fetchPosts();
      return right(dtos.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return left(mapDioException(e));
    } on FormatException catch (_) {
      return left(const ServerFailure(message: 'Invalid response'));
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }
}
