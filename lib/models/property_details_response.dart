import 'package:flutter_riverpod_template/models/property_response.dart';

class PropertyDetailsResponse {
  final bool success;
  final String message;
  final PropertyDetailsData data;

  PropertyDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PropertyDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PropertyDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class PropertyDetailsData {
  final PropertyDetail property;
  final List<MaintenanceHistory> maintenanceHistory;

  PropertyDetailsData({
    required this.property,
    required this.maintenanceHistory,
  });

  factory PropertyDetailsData.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsData(
      property: PropertyDetail.fromJson(json['property'] ?? {}),
      maintenanceHistory: (json['maintenanceHistory'] as List? ?? [])
          .map((e) => MaintenanceHistory.fromJson(e))
          .toList(),
    );
  }
}

class PropertyDetail {
  final String id;
  final String propertyCode;
  final String communityId;
  final String location;
  final String type;
  final bool isOccupied;
  final bool isActive;
  final List<PropertyImage> images;
  final CommunityInfo? community;

  PropertyDetail({
    required this.id,
    required this.propertyCode,
    required this.communityId,
    required this.location,
    required this.type,
    required this.isOccupied,
    required this.isActive,
    required this.images,
    this.community,
  });

  factory PropertyDetail.fromJson(Map<String, dynamic> json) {
    return PropertyDetail(
      id: "${json['id'] ?? ''}",
      propertyCode: "${json['propertyCode'] ?? ''}",
      communityId: "${json['communityId'] ?? ''}",
      location: "${json['location'] ?? ''}",
      type: "${json['type'] ?? ''}",
      isOccupied: json['isOccupied'] ?? false,
      isActive: json['isActive'] ?? false,
      images: (json['images'] as List? ?? [])
          .map((e) => PropertyImage.fromJson(e))
          .toList(),
      community: json['community'] != null ? CommunityInfo.fromJson(json['community']) : null,
    );
  }
}

class CommunityInfo {
  final String id;
  final String name;

  CommunityInfo({
    required this.id,
    required this.name,
  });

  factory CommunityInfo.fromJson(Map<String, dynamic> json) {
    return CommunityInfo(
      id: "${json['id'] ?? ''}",
      name: "${json['name'] ?? ''}",
    );
  }
}

class MaintenanceHistory {
  final String id;
  final String title;
  final String type;
  final String price;
  final String date;

  MaintenanceHistory({
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    required this.date,
  });

  factory MaintenanceHistory.fromJson(Map<String, dynamic> json) {
    return MaintenanceHistory(
      id: "${json['id'] ?? ''}",
      title: "${json['title'] ?? ''}",
      type: "${json['type'] ?? ''}",
      price: "${json['price'] ?? ''}",
      date: "${json['date'] ?? ''}",
    );
  }
}
