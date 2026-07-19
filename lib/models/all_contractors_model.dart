class AllContractorsModel {
  final bool success;
  final String message;
  final ContractorsData data;
  final Meta meta;

  AllContractorsModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory AllContractorsModel.fromJson(Map<String, dynamic> json) {
    return AllContractorsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ContractorsData.fromJson(json['data'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'meta': meta.toJson(),
    };
  }
}

class ContractorsData {
  final List<Contractor> contractors;

  ContractorsData({
    required this.contractors,
  });

  factory ContractorsData.fromJson(Map<String, dynamic> json) {
    return ContractorsData(
      contractors: (json['contractors'] as List<dynamic>?)
          ?.map((e) => Contractor.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractors': contractors.map((e) => e.toJson()).toList(),
    };
  }
}

class Contractor {
  final String id;
  final String userId;
  final String? companyName;
  final String? specialty;
  final String? licenseNo;
  final int rating;
  final int totalJobs;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? serviceId;
  final ContractorUser user;

  Contractor({
    required this.id,
    required this.userId,
    this.companyName,
    this.specialty,
    this.licenseNo,
    required this.rating,
    required this.totalJobs,
    this.createdAt,
    this.updatedAt,
    this.serviceId,
    required this.user,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      companyName: json['companyName'],
      specialty: json['specialty'],
      licenseNo: json['licenseNo'],
      rating: json['rating'] ?? 0,
      totalJobs: json['totalJobs'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      serviceId: json['serviceId'],
      user: ContractorUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'companyName': companyName,
      'specialty': specialty,
      'licenseNo': licenseNo,
      'rating': rating,
      'totalJobs': totalJobs,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'serviceId': serviceId,
      'user': user.toJson(),
    };
  }
}

class ContractorUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  ContractorUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  factory ContractorUser.fromJson(Map<String, dynamic> json) {
    return ContractorUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}