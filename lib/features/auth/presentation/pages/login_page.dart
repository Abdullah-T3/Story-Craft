import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:story_craft/features/auth/presentation/cubit/auth_state.dart';

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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: BlocListener<AuthCubit, AuthState>(
        listener: _handleAuthState,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 24.h),
                        _buildEmailField(),
                        SizedBox(height: 8.h),
                        _buildPasswordLabel(),
                        SizedBox(height: 8.h),
                        _buildPasswordField(),
                        SizedBox(height: 8.h),
                        _buildForgotPassword(),
                        SizedBox(height: 24.h),
                        _buildLoginButton(),
                        SizedBox(height: 20.h),
                        _buildOrDivider(),
                        SizedBox(height: 20.h),
                        _buildGoogleButton(),
                        SizedBox(height: 24.h),
                        _buildSignUpSection(),
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

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 40.h, bottom: 30.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF6E3),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF74C69D),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 36.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'مرحباً مجدداً!',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B1B1B),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'قصصك بانتظارك، هيا لنكمل المغامرة',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B6B6B),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8.h,
          right: 16.w,
          child: IconButton(
            onPressed: () {
              context.pushReplacementNamed(AppRoutes.homePath);
            },
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF2D6A4F),
              foregroundColor: Colors.white,
            ),
            icon: Icon(Icons.arrow_forward, size: 22.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'البريد الإلكتروني',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B1B1B),
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'أدخل بريدك هنا',
              hintStyle: TextStyle(
                color: const Color(0xFFAAAAAA),
                fontSize: 14.sp,
              ),
              suffixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: Color(0xFF2D6A4F),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: const Color(0xFF2D6A4F).withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: const Color(0xFF2D6A4F).withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(
                  color: Color(0xFF2D6A4F),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value.trim())) {
                return 'البريد الإلكتروني غير صالح';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordLabel() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        'كلمة المرور',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1B1B1B),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'كلمة المرور السرية',
          hintStyle: TextStyle(color: const Color(0xFFAAAAAA), fontSize: 14.sp),
          suffixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: Color(0xFF2D6A4F),
          ),
          prefixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFFAAAAAA),
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: const Color(0xFF2D6A4F).withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: const Color(0xFF2D6A4F).withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: Color(0xFF2D6A4F), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال كلمة المرور';
          }
          if (value.length < 6) {
            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: _showForgotPasswordDialog,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFE07A5F),
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE07A5F),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          height: 52.h,
          child: FilledButton(
            onPressed: isLoading ? null : _onLogin,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2D6A4F),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(
                0xFF2D6A4F,
              ).withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              textStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text('دخول'),
          ),
        );
      },
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: const Color(0xFFCCCCCC),
            thickness: 1,
            endIndent: 12.w,
          ),
        ),
        Text(
          'او',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
        ),
        Expanded(
          child: Divider(
            color: const Color(0xFFCCCCCC),
            thickness: 1,
            indent: 12.w,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          height: 52.h,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : _onGoogleLogin,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1B1B1B),
              side: const BorderSide(color: Color(0xFFDDDDDD)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: Image.network(
              'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
              width: 22.w,
              height: 22.w,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.g_mobiledata_rounded,
                size: 28.sp,
                color: const Color(0xFF4285F4),
              ),
            ),
            label: const Text('المتابعة باستخدام جوجل'),
          ),
        );
      },
    );
  }

  Widget _buildSignUpSection() {
    return Column(
      children: [
        Text(
          'ليس لديك حساب؟',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B6B6B)),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 48.h,
          width: 200.w,
          child: FilledButton(
            onPressed: () {
              context.pushNamed(AppRoutes.signUpPath);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE07A5F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('إنشاء حساب جديد'),
          ),
        ),
      ],
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

  void _onGoogleLogin() {
    context.read<AuthCubit>().loginWithGoogle();
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      context.pushNamedAndRemoveUntil(
        AppRoutes.homePath,
        predicate: (_) => false,
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(state.message),
          ),
          backgroundColor: Colors.red.shade700,
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
          backgroundColor: const Color(0xFF2D6A4F),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    final resetEmailController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('إعادة تعيين كلمة المرور'),
            content: TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: 'أدخل بريدك الإلكتروني',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () {
                  final email = resetEmailController.text.trim();
                  if (email.isNotEmpty) {
                    context.read<AuthCubit>().resetPassword(email: email);
                    Navigator.of(dialogContext).pop();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6A4F),
                ),
                child: const Text('إرسال'),
              ),
            ],
          ),
        );
      },
    );
    resetEmailController.dispose;
  }
}
