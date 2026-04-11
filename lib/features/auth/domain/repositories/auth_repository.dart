import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRepository {
  Future<AppResult<AppUser>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<AppResult<AppUser>> loginWithGoogle();

  Future<AppResult<void>> resetPassword({required String email});

  Future<AppResult<void>> logout();

  AppUser? get currentUser;
}
