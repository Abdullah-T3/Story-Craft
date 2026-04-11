import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/login_with_email_usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:story_craft/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:story_craft/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginWithEmailUseCase loginWithEmail,
    required LoginWithGoogleUseCase loginWithGoogle,
    required ResetPasswordUseCase resetPassword,
  })  : _loginWithEmail = loginWithEmail,
        _loginWithGoogle = loginWithGoogle,
        _resetPassword = resetPassword,
        super(const AuthInitial());

  final LoginWithEmailUseCase _loginWithEmail;
  final LoginWithGoogleUseCase _loginWithGoogle;
  final ResetPasswordUseCase _resetPassword;

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _loginWithEmail(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(const AuthLoading());
    final result = await _loginWithGoogle(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(const AuthLoading());
    final result = await _resetPassword(email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const ResetPasswordSent()),
    );
  }
}
