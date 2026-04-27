import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:story_craft/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:story_craft/features/notifications/presentation/widgets/notification_tile.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        appBar: AppBar(
          backgroundColor: AppColors.headerBackground,
          elevation: 0,
          centerTitle: true,
          title: Text(
            LocaleKeys.notifications_title.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state.unreadCount == 0) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () =>
                      context.read<NotificationsCubit>().markAllRead(),
                  child: Text(LocaleKeys.notifications_markAllRead.tr()),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state.isLoading && state.items.isEmpty) {
                return const AppLoading();
              }
              if (state.items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.r),
                    child: Text(
                      LocaleKeys.notifications_empty.tr(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<NotificationsCubit>().load(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  itemCount: state.items.length,
                  itemBuilder: (_, i) {
                    final n = state.items[i];
                    return NotificationTile(
                      notification: n,
                      onTap: () =>
                          context.read<NotificationsCubit>().markRead(n.id),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
