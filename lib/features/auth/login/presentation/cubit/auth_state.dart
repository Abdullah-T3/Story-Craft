import 'package:story_craft/features/auth/domain/entities/app_user.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);

  final AppUser user;
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;
}

final class ResetPasswordSent extends AuthState {
  const ResetPasswordSent();
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
