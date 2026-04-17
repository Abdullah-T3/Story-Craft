import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_craft/core/services/cloudinary/cloudinary_service.dart';
import 'package:story_craft/core/services/local_storage_service/flutter_secure_storage/secure_storage_helper.dart';
import 'package:story_craft/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart';
import 'package:story_craft/core/theme/theme_cubit.dart';
import 'package:story_craft/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:story_craft/features/auth/data/datasources/firestore_user_datasource.dart';
import 'package:story_craft/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_craft/features/auth/domain/usecases/login_with_email_usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/logout_usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_cubit.dart';
import 'package:story_craft/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt
    // Core services
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton(SecureStorageHelper.new)
    ..registerLazySingleton(() => SharedPrefsHelper(getIt<SharedPreferences>()))
    ..registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(getIt<SharedPrefsHelper>()),
    )
    ..registerLazySingleton(CloudinaryService.new)
    // Auth
    ..registerLazySingleton(FirestoreUserDatasource.new)
    ..registerLazySingleton(
      () => FirebaseAuthDatasource(
        firestoreUserDatasource: getIt<FirestoreUserDatasource>(),
        cloudinaryService: getIt<CloudinaryService>(),
      ),
    )
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
    ..registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()))
    ..registerLazySingleton(() => SignUpUseCase(getIt<AuthRepository>()))
    // Cubits
    ..registerFactory(
      () => AuthCubit(
        loginWithEmail: getIt<LoginWithEmailUseCase>(),
        loginWithGoogle: getIt<LoginWithGoogleUseCase>(),
        resetPassword: getIt<ResetPasswordUseCase>(),
        logout: getIt<LogoutUseCase>(),
      ),
    )
    ..registerFactory(() => SignUpCubit(getIt<SignUpUseCase>()));
}
