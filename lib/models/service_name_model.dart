class ServiceNameModel {
  final bool success;
  final String message;
  final List<ServiceCategory> data;

  ServiceNameModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceNameModel.fromJson(Map<String, dynamic> json) {
    return ServiceNameModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ServiceCategory.fromJson(e))
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

class ServiceCategory {
  final String id;
  final String name;

  ServiceCategory({
    required this.id,
    required this.name,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
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