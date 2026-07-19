class ProfileModel {
  final bool success;
  final String message;
  final ProfileData data;

  ProfileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class ProfileData {
  final User user;

  ProfileData({
    required this.user,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
  };
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? avatarUrl;
  final bool isEmailVerified;
  final bool isActive;
  final DateTime? lastActiveAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserProfile? housingManager;
  final dynamic contractor;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    required this.isEmailVerified,
    required this.isActive,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
    this.housingManager,
    this.contractor,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      avatarUrl: json['avatarUrl'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      isActive: json['isActive'] ?? false,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      housingManager: json['housingManager'] != null
          ? UserProfile.fromJson(json['housingManager'])
          : null,
      contractor: json['contractor'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'avatarUrl': avatarUrl,
    'isEmailVerified': isEmailVerified,
    'isActive': isActive,
    'lastActiveAt': lastActiveAt?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'housingManager': housingManager?.toJson(),
    'contractor': contractor,
  };
}

class UserProfile {
  final String id;
  final String communityId;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    required this.communityId,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      communityId: json['communityId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'communityId': communityId,
    'createdAt': createdAt?.toIso8601String(),
  };
}