import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_craft/core/services/local_storage_service/flutter_secure_storage/secure_storage_helper.dart';
import 'package:story_craft/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart';
import 'package:story_craft/core/theme/theme_cubit.dart';
import 'package:story_craft/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:story_craft/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_craft/features/auth/domain/usecases/login_with_email_usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:story_craft/features/auth/presentation/cubit/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt
    // Core services
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton(SecureStorageHelper.new)
    ..registerLazySingleton(() => SharedPrefsHelper(getIt<SharedPreferences>()))
    ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
    // Auth
    ..registerLazySingleton(FirebaseAuthDatasource.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<FirebaseAuthDatasource>()),
    )
    ..registerLazySingleton(
      () => LoginWithEmailUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton(
      () => LoginWithGoogleUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton(() => ResetPasswordUseCase(getIt<AuthRepository>()))
    ..registerFactory(
      () => AuthCubit(
        loginWithEmail: getIt<LoginWithEmailUseCase>(),
        loginWithGoogle: getIt<LoginWithGoogleUseCase>(),
        resetPassword: getIt<ResetPasswordUseCase>(),
      ),
    );
}
