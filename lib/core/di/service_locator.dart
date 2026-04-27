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
import 'package:story_craft/features/profile/data/datasources/firestore_profile_datasource.dart';
import 'package:story_craft/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';
import 'package:story_craft/features/profile/domain/usecases/get_achievements_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_parental_settings_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_reader_profile_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_saved_stories_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/update_parental_settings_usecase.dart';
import 'package:story_craft/features/profile/presentation/cubit/account/account_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/achievements/achievements_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/parental/parental_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/saved_stories/saved_stories_cubit.dart';

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
    // Profile
    ..registerLazySingleton(FirestoreProfileDatasource.new)
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        firestore: getIt<FirestoreProfileDatasource>(),
        auth: getIt<AuthRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => GetReaderProfileUseCase(getIt<ProfileRepository>()),
    )
    ..registerLazySingleton(
      () => GetAchievementsUseCase(getIt<ProfileRepository>()),
    )
    ..registerLazySingleton(
      () => GetSavedStoriesUseCase(getIt<ProfileRepository>()),
    )
    ..registerLazySingleton(
      () => GetParentalSettingsUseCase(getIt<ProfileRepository>()),
    )
    ..registerLazySingleton(
      () => UpdateParentalSettingsUseCase(getIt<ProfileRepository>()),
    )
    // Cubits
    ..registerFactory(
      () => AuthCubit(
        loginWithEmail: getIt<LoginWithEmailUseCase>(),
        loginWithGoogle: getIt<LoginWithGoogleUseCase>(),
        resetPassword: getIt<ResetPasswordUseCase>(),
        logout: getIt<LogoutUseCase>(),
      ),
    )
    ..registerFactory(() => SignUpCubit(getIt<SignUpUseCase>()))
    ..registerFactory(() => AccountCubit(getIt<GetReaderProfileUseCase>()))
    ..registerFactory(
      () => AchievementsCubit(getIt<GetAchievementsUseCase>()),
    )
    ..registerFactory(
      () => SavedStoriesCubit(getIt<GetSavedStoriesUseCase>()),
    )
    ..registerFactory(
      () => ParentalCubit(
        getSettings: getIt<GetParentalSettingsUseCase>(),
        updateSettings: getIt<UpdateParentalSettingsUseCase>(),
      ),
    );
}
