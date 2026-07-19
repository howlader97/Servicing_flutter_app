class IssueModel {
  final bool success;
  final String message;
  final IssueData data;
  final Meta meta;

  IssueModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: IssueData.fromJson(json['data'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class IssueData {
  final List<Issue> issues;

  IssueData({
    required this.issues,
  });

  factory IssueData.fromJson(Map<String, dynamic> json) {
    return IssueData(
      issues: (json['issues'] as List<dynamic>?)
          ?.map((e) => Issue.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Issue {
  final String id;
  final String title;
  final String description;
  final String propertyId;
  final String reportedById;
  final String categoryId;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Property property;
  final Category category;
  final List<String> images;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.propertyId,
    required this.reportedById,
    required this.categoryId,
    required this.isResolved,
    required this.createdAt,
    required this.updatedAt,
    required this.property,
    required this.category,
    required this.images,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      propertyId: json['propertyId'] ?? '',
      reportedById: json['reportedById'] ?? '',
      categoryId: json['categoryId'] ?? '',
      isResolved: json['isResolved'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      property: Property.fromJson(json['property'] ?? {}),
      category: Category.fromJson(json['category'] ?? {}),
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class Property {
  final String propertyCode;
  final String location;

  Property({
    required this.propertyCode,
    required this.location,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      propertyCode: json['propertyCode'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class Category {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
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