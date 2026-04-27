import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/notifications/domain/entities/app_notification.dart';

abstract interface class NotificationsRepository {
  Future<AppResult<List<AppNotification>>> getNotifications();

  Future<AppResult<void>> markAsRead(String id);

  Future<AppResult<void>> markAllRead();

  Future<AppResult<int>> getUnreadCount();
}
