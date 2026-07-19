import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/notifications_model.dart';
import 'package:flutter_riverpod_template/services/repository/notification_repository.dart';

class HousingNotificationState {
  final List<NotificationItem> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;

  HousingNotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
  });

  HousingNotificationState copyWith({
    List<NotificationItem>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
  }) {
    return HousingNotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class HousingNotificationNotifier extends Notifier<HousingNotificationState> {
  @override
  HousingNotificationState build() {
    Future.microtask(() => fetchNotifications());
    return HousingNotificationState();
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true);
    final repo = NotificationRepository.instance;
    final model = await repo.getNotifications();
    final unread = await repo.getUnreadCount();

    if (model != null && model.success) {
      state = state.copyWith(
        notifications: model.data.notifications,
        isLoading: false,
        unreadCount: unread ?? 0,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to fetch notifications",
      );
    }
  }

  Future<void> markSingleAsRead(String id) async {
    final repo = NotificationRepository.instance;
    final success = await repo.markSingleAsRead(id);
    if (success) {
      final updatedList = state.notifications.map((item) {
        if (item.id == id) {
          return NotificationItem(
            id: item.id,
            userId: item.userId,
            type: item.type,
            title: item.title,
            body: item.body,
            data: item.data,
            isRead: true,
            readAt: DateTime.now().toIso8601String(),
            createdAt: item.createdAt,
          );
        }
        return item;
      }).toList();

      state = state.copyWith(
        notifications: updatedList,
        unreadCount: (state.unreadCount - 1).clamp(0, 999999),
      );
    }
  }

  Future<void> markAllAsRead() async {
    final repo = NotificationRepository.instance;
    final success = await repo.markAllAsRead();
    if (success) {
      final updatedList = state.notifications.map((item) {
        return NotificationItem(
          id: item.id,
          userId: item.userId,
          type: item.type,
          title: item.title,
          body: item.body,
          data: item.data,
          isRead: true,
          readAt: DateTime.now().toIso8601String(),
          createdAt: item.createdAt,
        );
      }).toList();

      state = state.copyWith(notifications: updatedList, unreadCount: 0);
    }
  }
}

final housingNotificationProvider =
    NotifierProvider.autoDispose<
      HousingNotificationNotifier,
      HousingNotificationState
    >(() {
      return HousingNotificationNotifier();
    });
