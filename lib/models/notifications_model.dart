class NotificationsModel {
  final bool success;
  final String message;
  final NotificationData data;
  final Meta meta;

  NotificationsModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class NotificationData {
  final List<NotificationItem> notifications;

  NotificationData({
    required this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: (json['notifications'] as List<dynamic>? ?? [])
          .map((e) => NotificationItem.fromJson(e))
          .toList(),
    );
  }
}

class NotificationItem {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final NotificationPayload data;
  final bool isRead;
  final String? readAt;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: NotificationPayload.fromJson(json['data'] ?? {}),
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class NotificationPayload {
  final String? type;
  final String? jobId;
  final String? screen;
  final String? referenceId;
  final String? communityId;

  NotificationPayload({
    this.type,
    this.jobId,
    this.screen,
    this.referenceId,
    this.communityId,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      type: json['type'],
      jobId: json['jobId'],
      screen: json['screen'],
      referenceId: json['referenceId'],
      communityId: json['communityId'],
    );
  }
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}