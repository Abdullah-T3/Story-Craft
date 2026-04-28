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
import 'package:story_craft/features/stories/presentation/cubit/create_story/create_story_cubit.dart';
import 'package:story_craft/features/notifications/data/datasources/firestore_notifications_datasource.dart';
import 'package:story_craft/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:story_craft/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:story_craft/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:story_craft/features/profile/data/datasources/firestore_profile_datasource.dart';
import 'package:story_craft/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';
import 'package:story_craft/features/profile/domain/usecases/get_achievements_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_parental_settings_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_reader_profile_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_saved_stories_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/update_parental_settings_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:story_craft/features/profile/presentation/cubit/account/account_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/achievements/achievements_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/parental/parental_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/personal_info/personal_info_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/saved_stories/saved_stories_cubit.dart';
import 'package:story_craft/features/stories/data/datasources/firestore_stories_datasource.dart';
import 'package:story_craft/features/stories/data/repositories/stories_repository_impl.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';
import 'package:story_craft/features/stories/domain/usecases/create_story_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/get_stories_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/get_story_by_id_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/get_story_of_the_day_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/save_progress_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/search_stories_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/toggle_favorite_usecase.dart';
import 'package:story_craft/features/stories/presentation/cubit/library/library_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/search/search_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/story_details/story_details_cubit.dart';
import 'package:story_craft/features/stories/presentation/cubit/story_reader/story_reader_cubit.dart';

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
    // Stories
    ..registerLazySingleton(FirestoreStoriesDatasource.new)
    ..registerLazySingleton<StoriesRepository>(
      () => StoriesRepositoryImpl(
        firestore: getIt<FirestoreStoriesDatasource>(),
        auth: getIt<AuthRepository>(),
      ),
    )
    ..registerLazySingleton(() => GetStoriesUseCase(getIt<StoriesRepository>()))
    ..registerLazySingleton(
      () => GetStoryByIdUseCase(getIt<StoriesRepository>()),
    )
    ..registerLazySingleton(
      () => GetStoryOfTheDayUseCase(getIt<StoriesRepository>()),
    )
    ..registerLazySingleton(
      () => SearchStoriesUseCase(getIt<StoriesRepository>()),
    )
    ..registerLazySingleton(
      () => ToggleFavoriteUseCase(getIt<StoriesRepository>()),
    )
    ..registerLazySingleton(
      () => SaveProgressUseCase(getIt<StoriesRepository>()),
    )
    ..registerLazySingleton(
      () => CreateStoryUseCase(getIt<StoriesRepository>()),
    )
    // Profile
    ..registerLazySingleton(FirestoreProfileDatasource.new)
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        firestore: getIt<FirestoreProfileDatasource>(),
        auth: getIt<AuthRepository>(),
        stories: getIt<StoriesRepository>(),
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
    ..registerLazySingleton(
      () => UpdateProfileUseCase(getIt<ProfileRepository>()),
    )
    // Notifications
    ..registerLazySingleton(FirestoreNotificationsDatasource.new)
    ..registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(
        firestore: getIt<FirestoreNotificationsDatasource>(),
        auth: getIt<AuthRepository>(),
      ),
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
    )
    ..registerFactory(
      () => PersonalInfoCubit(
        getProfile: getIt<GetReaderProfileUseCase>(),
        updateProfile: getIt<UpdateProfileUseCase>(),
      ),
    )
    ..registerFactory(
      () => LibraryCubit(
        getStories: getIt<GetStoriesUseCase>(),
        getStoryOfTheDay: getIt<GetStoryOfTheDayUseCase>(),
        getParental: getIt<GetParentalSettingsUseCase>(),
      ),
    )
    ..registerFactory(
      () => StoryDetailsCubit(
        getStoryById: getIt<GetStoryByIdUseCase>(),
        toggleFavorite: getIt<ToggleFavoriteUseCase>(),
        repository: getIt<StoriesRepository>(),
      ),
    )
    ..registerFactory(
      () => StoryReaderCubit(
        getStoryById: getIt<GetStoryByIdUseCase>(),
        saveProgress: getIt<SaveProgressUseCase>(),
        repository: getIt<StoriesRepository>(),
        getParental: getIt<GetParentalSettingsUseCase>(),
        updateParental: getIt<UpdateParentalSettingsUseCase>(),
      ),
    )
    ..registerFactory(
      () => SearchCubit(
        searchStories: getIt<SearchStoriesUseCase>(),
        prefs: getIt<SharedPrefsHelper>(),
      ),
    )
    ..registerFactory(
      () => NotificationsCubit(getIt<NotificationsRepository>()),
    )
    ..registerFactory(
      () => CreateStoryCubit(
        createStory: getIt<CreateStoryUseCase>(),
        cloudinary: getIt<CloudinaryService>(),
      ),
    );
}
