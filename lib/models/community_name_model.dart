class CommunityNameModel {
  final bool success;
  final String message;
  final List<Community> data;

  CommunityNameModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CommunityNameModel.fromJson(Map<String, dynamic> json) {
    return CommunityNameModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Community.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Community {
  final String id;
  final String name;

  Community({
    required this.id,
    required this.name,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: "${json['id'] ?? ''}",
      name: "${json['name'] ?? ''}",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}