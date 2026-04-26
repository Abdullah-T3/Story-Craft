import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/main_scaffold.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_cubit.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_state.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/forgot_password_dialog.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/login_button.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/login_email_field.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/login_forgot_password_button.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/login_google_button.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/login_header.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/login_or_divider.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/login_password_field.dart';
import 'package:story_craft/features/auth/login/presentation/widgets/login_signup_section.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: BlocListener<AuthCubit, AuthState>(
        listener: _handleAuthState,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                LoginHeader(
                  onBackPressed: () =>
                      context.pushReplacementNamed(AppRoutes.homePath),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 24.h),
                        LoginEmailField(controller: _emailController),
                        SizedBox(height: 16.h),
                        LoginPasswordField(controller: _passwordController),
                        SizedBox(height: 8.h),
                        LoginForgotPasswordButton(
                          onPressed: () => ForgotPasswordDialog.show(context),
                        ),
                        SizedBox(height: 24.h),
                        LoginButton(onPressed: _onLogin),
                        SizedBox(height: 20.h),
                        const LoginOrDivider(),
                        SizedBox(height: 20.h),
                        LoginGoogleButton(onPressed: _onGoogleLogin),
                        SizedBox(height: 24.h),
                        LoginSignUpSection(
                          onPressed: () =>
                              context.pushNamed(AppRoutes.signUpPath),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _onGoogleLogin() => context.read<AuthCubit>().loginWithGoogle();

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      context.pushNamedAndRemoveUntil(
        AppRoutes.mainLayoutPath,
        predicate: (_) => false,
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(state.message),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    } else if (state is ResetPasswordSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text('تم إرسال رابط إعادة تعيين كلمة المرور'),
          ),
          backgroundColor: AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }
}
