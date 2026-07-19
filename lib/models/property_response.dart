class PropertyResponse {
  final bool success;
  final String message;
  final PropertyData data;

  PropertyResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    return PropertyResponse(
      success: json['success'],
      message: json['message'],
      data: PropertyData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class PropertyData {
  final List<Property> properties;

  PropertyData({required this.properties});

  factory PropertyData.fromJson(Map<String, dynamic> json) {
    return PropertyData(
      properties: (json['properties'] as List)
          .map((e) => Property.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'properties': properties.map((e) => e.toJson()).toList(),
    };
  }
}

class Property {
  final String id;
  final String propertyCode;
  final String communityId;
  final String location;
  final String type;
  final bool isOccupied;
  final bool isActive;
  final DateTime lastInvestigation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PropertyImage> images;

  Property({
    required this.id,
    required this.propertyCode,
    required this.communityId,
    required this.location,
    required this.type,
    required this.isOccupied,
    required this.isActive,
    required this.lastInvestigation,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: "${json['id'] ?? ''}",
      propertyCode: json['propertyCode'],
      communityId: json['communityId'],
      location: json['location'],
      type: json['type'],
      isOccupied: json['isOccupied'],
      isActive: json['isActive'],
      lastInvestigation: DateTime.parse(json['lastInvestigation']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      images: (json['images'] as List)
          .map((e) => PropertyImage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyCode': propertyCode,
      'communityId': communityId,
      'location': location,
      'type': type,
      'isOccupied': isOccupied,
      'isActive': isActive,
      'lastInvestigation': lastInvestigation.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'images': images.map((e) => e.toJson()).toList(),
    };
  }
}

class PropertyImage {
  final String id;
  final String propertyId;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;
  final DateTime createdAt;

  PropertyImage({
    required this.id,
    required this.propertyId,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
    required this.createdAt,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: "${json['id'] ?? ''}",
      propertyId: "${json['propertyId'] ?? ''}",
      imageUrl: json['imageUrl'],
      isPrimary: json['isPrimary'],
      sortOrder: int.tryParse("${json['sortOrder'] ?? 0}") ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'imageUrl': imageUrl,
      'isPrimary': isPrimary,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}