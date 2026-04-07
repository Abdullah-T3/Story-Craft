import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_craft/app/router/app_router.dart';
import 'package:story_craft/core/config/app_config.dart';
import 'package:story_craft/core/localization/locale_cubit.dart';
import 'package:story_craft/core/network/dio_client.dart';
import 'package:story_craft/core/network/network_info.dart';
import 'package:story_craft/core/services/local_storage_service/flutter_secure_storage/secure_storage_helper.dart';
import 'package:story_craft/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart';
import 'package:story_craft/core/theme/theme_cubit.dart';
import 'package:story_craft/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:story_craft/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:story_craft/features/posts/domain/repositories/posts_repository.dart';
import 'package:story_craft/features/posts/presentation/cubit/posts_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  const config = AppConfig();

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton(SecureStorageHelper.new)
    ..registerLazySingleton(() => SharedPrefsHelper(getIt<SharedPreferences>()))
    ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
    ..registerLazySingleton<LocaleCubit>(LocaleCubit.new)
    ..registerLazySingleton<Dio>(() => createDio(getIt<AppConfig>()))
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()))
    ..registerLazySingleton<GoRouter>(AppRouter.create)
    ..registerLazySingleton<PostsRemoteDataSource>(
      () => PostsRemoteDataSource(getIt<Dio>()),
    )
    ..registerLazySingleton<PostsRepository>(
      () => PostsRepositoryImpl(
        getIt<PostsRemoteDataSource>(),
        getIt<NetworkInfo>(),
      ),
    )
    ..registerFactory(() => PostsCubit(getIt<PostsRepository>()));
}
