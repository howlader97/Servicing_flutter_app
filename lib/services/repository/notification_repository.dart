import 'package:flutter_riverpod_template/models/notifications_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class NotificationRepository {
  NotificationRepository._privateConstructor();

  static final NotificationRepository _instance =
      NotificationRepository._privateConstructor();

  static NotificationRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;

  Future<NotificationsModel?> getNotifications() async {
    try {
      final response = await _apiServices.getServices("/notifications");
      if (response != null) {
        return NotificationsModel.fromJson(response);
      }
    } catch (e) {
      errorLog("getNotifications repo error", e);
    }
    return null;
  }

  Future<int?> getUnreadCount() async {
    try {
      final response = await _apiServices.getServices(
        "/notifications/unread-count",
      );
      if (response != null && response['success'] == true) {
        final data = response['data'];
        if (data is Map) {
          return data['count'] ?? 0;
        } else if (data is num) {
          return data.toInt();
        }
      }
    } catch (e) {
      errorLog("getUnreadCount repo error", e);
    }
    return null;
  }

  Future<bool> markAllAsRead() async {
    try {
      final response = await _apiServices.putServices(
        url: "/notifications/read-all",
        body: {},
      );
      return response != null;
    } catch (e) {
      errorLog("markAllAsRead repo error", e);
    }
    return false;
  }

  Future<bool> markSingleAsRead(String id) async {
    try {
      final response = await _apiServices.putServices(
        url: "/notifications/$id/read",
        body: {},
      );
      return response != null;
    } catch (e) {
      errorLog("markSingleAsRead repo error", e);
    }
    return false;
  }
}
