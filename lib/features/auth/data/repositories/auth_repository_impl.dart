import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:story_craft/features/auth/domain/entities/app_user.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final FirebaseAuthDatasource _datasource;

  @override
  Future<AppResult<AppUser>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _datasource.loginWithEmail(
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        message: _mapFirebaseErrorMessage(e.code),
        code: e.code,
      ));
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<AppResult<AppUser>> loginWithGoogle() async {
    try {
      final user = await _datasource.loginWithGoogle();
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        message: _mapFirebaseErrorMessage(e.code),
        code: e.code,
      ));
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<AppResult<void>> resetPassword({required String email}) async {
    try {
      await _datasource.resetPassword(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        message: _mapFirebaseErrorMessage(e.code),
        code: e.code,
      ));
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<AppResult<void>> logout() async {
    try {
      await _datasource.logout();
      return const Right(null);
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ أثناء تسجيل الخروج'));
    }
  }

  @override
  AppUser? get currentUser => _datasource.currentUser;

  String _mapFirebaseErrorMessage(String code) {
    return switch (code) {
      'user-not-found' => 'لا يوجد حساب بهذا البريد الإلكتروني',
      'wrong-password' => 'كلمة المرور غير صحيحة',
      'invalid-email' => 'البريد الإلكتروني غير صالح',
      'user-disabled' => 'تم تعطيل هذا الحساب',
      'too-many-requests' => 'محاولات كثيرة، حاول لاحقاً',
      'invalid-credential' => 'بيانات الدخول غير صحيحة',
      'google-sign-in-cancelled' => 'تم إلغاء تسجيل الدخول بجوجل',
      _ => 'حدث خطأ، حاول مرة أخرى',
    };
  }
}
