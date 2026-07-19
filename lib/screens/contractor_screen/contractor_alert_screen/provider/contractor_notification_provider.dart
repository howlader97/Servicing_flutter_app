import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/notifications_model.dart';
import 'package:flutter_riverpod_template/services/repository/notification_repository.dart';

class ContractorNotificationState {
  final List<NotificationItem> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;

  ContractorNotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
  });

  ContractorNotificationState copyWith({
    List<NotificationItem>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
  }) {
    return ContractorNotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class ContractorNotificationNotifier
    extends Notifier<ContractorNotificationState> {
  @override
  ContractorNotificationState build() {
    Future.microtask(() => fetchNotifications());
    return ContractorNotificationState();
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
      state = state.copyWith(isLoading: false, error: "Failed to fetch alerts");
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

final contractorNotificationProvider =
    NotifierProvider.autoDispose<
      ContractorNotificationNotifier,
      ContractorNotificationState
    >(() {
      return ContractorNotificationNotifier();
    });
