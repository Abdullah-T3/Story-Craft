import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:story_craft/features/notifications/presentation/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo) : super(const NotificationsState());

  final NotificationsRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repo.getNotifications();
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(state.copyWith(isLoading: false, items: list)),
    );
  }

  Future<void> markRead(String id) async {
    emit(
      state.copyWith(
        items: state.items
            .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
            .toList(),
      ),
    );
    await _repo.markAsRead(id);
  }

  Future<void> markAllRead() async {
    emit(
      state.copyWith(
        items: state.items.map((n) => n.copyWith(isRead: true)).toList(),
      ),
    );
    await _repo.markAllRead();
  }
}
