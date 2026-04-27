import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_craft/features/notifications/data/datasources/firestore_notifications_datasource.dart';
import 'package:story_craft/features/notifications/domain/entities/app_notification.dart';
import 'package:story_craft/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl({
    required FirestoreNotificationsDatasource firestore,
    required AuthRepository auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirestoreNotificationsDatasource _firestore;
  final AuthRepository _auth;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<AppResult<List<AppNotification>>> getNotifications() async {
    final uid = _uid;
    if (uid == null) return const Right([]);
    try {
      final docs = await _firestore.getAll(uid);
      if (docs.isEmpty) return const Right([]);
      return Right(docs.map(_fromMap).toList());
    } on Exception {
      return const Right([]);
    }
  }

  @override
  Future<AppResult<int>> getUnreadCount() async {
    final uid = _uid;
    if (uid == null) return const Right(0);
    try {
      return Right(await _firestore.getUnreadCount(uid));
    } on Exception {
      return const Right(0);
    }
  }

  @override
  Future<AppResult<void>> markAsRead(String id) async {
    final uid = _uid;
    if (uid == null) return const Right(null);
    try {
      await _firestore.markRead(uid, id);
      return const Right(null);
    } on Exception {
      return const Left(ServerFailure(message: 'تعذر تحديث الإشعار'));
    }
  }

  @override
  Future<AppResult<void>> markAllRead() async {
    final uid = _uid;
    if (uid == null) return const Right(null);
    try {
      await _firestore.markAllRead(uid);
      return const Right(null);
    } on Exception {
      return const Left(ServerFailure(message: 'تعذر تحديث الإشعارات'));
    }
  }

  AppNotification _fromMap(Map<String, dynamic> data) {
    final ts = data['createdAt'];
    return AppNotification(
      id: data['id'] as String,
      kind: _kindFromString((data['type'] ?? 'reminder') as String),
      title: (data['title'] ?? '') as String,
      body: (data['body'] ?? '') as String,
      isRead: (data['isRead'] ?? false) as bool,
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
      payload: (data['payload'] as Map?)?.cast<String, dynamic>(),
    );
  }

  NotificationKind _kindFromString(String s) {
    return switch (s) {
      'newStory' => NotificationKind.newStory,
      'badge' => NotificationKind.badge,
      _ => NotificationKind.reminder,
    };
  }
}
