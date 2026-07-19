class RecentActivityModel {
  final bool success;
  final String message;
  final ActivityData data;

  RecentActivityModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ActivityData.fromJson(json['data'] ?? {}),
    );
  }
}

class ActivityData {
  final List<Activity> activity;

  ActivityData({
    required this.activity,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      activity: (json['activity'] as List<dynamic>?)
          ?.map((e) => Activity.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Activity {
  final String id;
  final String title;
  final String status;
  final DateTime updatedAt;
  final ActivityProperty property;

  Activity({
    required this.id,
    required this.title,
    required this.status,
    required this.updatedAt,
    required this.property,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? (DateTime.tryParse(json['updatedAt']) ?? DateTime.now())
          : DateTime.now(),
      property: ActivityProperty.fromJson(json['property'] ?? {}),
    );
  }
}

class ActivityProperty {
  final String propertyCode;
  final String location;

  ActivityProperty({
    required this.propertyCode,
    required this.location,
  });

  factory ActivityProperty.fromJson(Map<String, dynamic> json) {
    return ActivityProperty(
      propertyCode: json['propertyCode'] ?? '',
      location: json['location'] ?? '',
    );
  }
}