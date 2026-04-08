import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_craft/core/services/local_storage_service/flutter_secure_storage/secure_storage_helper.dart';
import 'package:story_craft/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart';
import 'package:story_craft/core/theme/theme_cubit.dart';
import 'package:story_craft/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:story_craft/features/posts/domain/repositories/posts_repository.dart';
import 'package:story_craft/features/posts/presentation/cubit/posts_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton(SecureStorageHelper.new)
    ..registerLazySingleton(() => SharedPrefsHelper(getIt<SharedPreferences>()))
    ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
    ..registerLazySingleton<PostsRepository>(() => const PostsRepositoryImpl())
    ..registerFactory(() => PostsCubit(getIt<PostsRepository>()));
}
