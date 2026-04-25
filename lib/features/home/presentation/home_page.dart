import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/widgets/app_inline_loader.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_cubit.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          context.pushNamedAndRemoveUntil(
            AppRoutes.loginPath,
            predicate: (_) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(state.message),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الرئيسية'),
          actions: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final loading = state is AuthLoading;
                return IconButton(
                  icon: loading
                      ? const AppInlineLoader(size: 20, color: Colors.black54, strokeWidth: 2)
                      : const Icon(Icons.logout),
                  tooltip: 'تسجيل الخروج',
                  onPressed: loading
                      ? null
                      : () => _confirmLogout(context),
                );
              },
            ),
          ],
        ),
        body: const Center(child: Text('Welcom to home screen')),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final cubit = context.read<AuthCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
    if (confirmed ?? false) {
      await cubit.logout();
    }
  }
}
