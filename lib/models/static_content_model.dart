class StaticContentModel {
  final bool success;
  final String message;
  final StaticContentData? data;

  StaticContentModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory StaticContentModel.fromJson(Map<String, dynamic> json) {
    return StaticContentModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? StaticContentData.fromJson(json['data']) : null,
    );
  }
}

class StaticContentData {
  final StaticContent? content;

  StaticContentData({this.content});

  factory StaticContentData.fromJson(Map<String, dynamic> json) {
    return StaticContentData(
      content: json['content'] != null ? StaticContent.fromJson(json['content']) : null,
    );
  }
}

class StaticContent {
  final String id;
  final String slug;
  final String title;
  final String content;
  final int version;
  final String updatedAt;
  final String createdAt;

  StaticContent({
    required this.id,
    required this.slug,
    required this.title,
    required this.content,
    required this.version,
    required this.updatedAt,
    required this.createdAt,
  });

  factory StaticContent.fromJson(Map<String, dynamic> json) {
    return StaticContent(
      id: "${json['id'] ?? ''}",
      slug: "${json['slug'] ?? ''}",
      title: "${json['title'] ?? ''}",
      content: "${json['content'] ?? ''}",
      version: json['version'] ?? 0,
      updatedAt: "${json['updatedAt'] ?? ''}",
      createdAt: "${json['createdAt'] ?? ''}",
    );
  }
}
