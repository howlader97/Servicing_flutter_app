class AllJobsModel {
  final bool success;
  final String message;
  final JobData data;
  final Meta meta;

  AllJobsModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory AllJobsModel.fromJson(Map<String, dynamic> json) {
    return AllJobsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: JobData.fromJson(json['data'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
    'meta': meta.toJson(),
  };
}

class JobData {
  final List<Job> jobs;

  JobData({required this.jobs});

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      jobs: (json['jobs'] as List? ?? [])
          .map((e) => Job.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'jobs': jobs.map((e) => e.toJson()).toList(),
  };
}

class Job {
  final String id;
  final String jobNumber;
  final String title;
  final String description;
  final String status;
  final String priority;

  final String propertyId;
  final String issueId;
  final String assignedToId;
  final String createdById;

  final DateTime scheduledDate;
  final DateTime startedAt;
  final DateTime? completedAt;

  final num estimatedCost;
  final num actualCost;

  final String? notes;
  final String? tenantName;
  final String? tenantPhone;

  final DateTime createdAt;
  final DateTime updatedAt;

  final Property property;
  final AssignedTo assignedTo;

  final List<JobImage> images;
  final JobCount count;

  Job({
    required this.id,
    required this.jobNumber,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.propertyId,
    required this.issueId,
    required this.assignedToId,
    required this.createdById,
    required this.scheduledDate,
    required this.startedAt,
    required this.completedAt,
    required this.estimatedCost,
    required this.actualCost,
    required this.notes,
    required this.tenantName,
    required this.tenantPhone,
    required this.createdAt,
    required this.updatedAt,
    required this.property,
    required this.assignedTo,
    required this.images,
    required this.count,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '',
      jobNumber: json['jobNumber'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      propertyId: json['propertyId'] ?? '',
      issueId: json['issueId'] ?? '',
      assignedToId: json['assignedToId'] ?? '',
      createdById: json['createdById'] ?? '',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.tryParse(json['scheduledDate']) ?? DateTime.now()
          : DateTime.now(),
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt']) ?? DateTime.now()
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
      estimatedCost: json['estimatedCost'] ?? 0,
      actualCost: json['actualCost'] ?? 0,
      notes: json['notes'],
      tenantName: json['tenantName'],
      tenantPhone: json['tenantPhone'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      property: Property.fromJson(json['property'] ?? {}),
      assignedTo: AssignedTo.fromJson(json['assignedTo'] ?? {}),
      images: (json['images'] as List? ?? [])
          .map((e) => JobImage.fromJson(e))
          .toList(),
      count: JobCount.fromJson(json['_count'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'jobNumber': jobNumber,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'propertyId': propertyId,
    'issueId': issueId,
    'assignedToId': assignedToId,
    'createdById': createdById,
    'scheduledDate': scheduledDate.toIso8601String(),
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'estimatedCost': estimatedCost,
    'actualCost': actualCost,
    'notes': notes,
    'tenantName': tenantName,
    'tenantPhone': tenantPhone,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'property': property.toJson(),
    'assignedTo': assignedTo.toJson(),
    'images': images.map((e) => e.toJson()).toList(),
    '_count': count.toJson(),
  };
}

class JobImage {
  final String id;
  final String jobId;
  final String imageUrl;
  final String? caption;
  final DateTime createdAt;

  JobImage({
    required this.id,
    required this.jobId,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
  });

  factory JobImage.fromJson(Map<String, dynamic> json) {
    return JobImage(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      caption: json['caption'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'jobId': jobId,
    'imageUrl': imageUrl,
    'caption': caption,
    'createdAt': createdAt.toIso8601String(),
  };
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

  Map<String, dynamic> toJson() => {
    'propertyCode': propertyCode,
    'location': location,
  };
}

class AssignedTo {
  final String id;
  final String userId;
  final String companyName;
  final String specialty;
  final String licenseNo;
  final int rating;
  final int totalJobs;
  final User user;

  AssignedTo({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.specialty,
    required this.licenseNo,
    required this.rating,
    required this.totalJobs,
    required this.user,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      companyName: json['companyName'] ?? '',
      specialty: json['specialty'] ?? '',
      licenseNo: json['licenseNo'] ?? '',
      rating: json['rating'] ?? 0,
      totalJobs: json['totalJobs'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'companyName': companyName,
    'specialty': specialty,
    'licenseNo': licenseNo,
    'rating': rating,
    'totalJobs': totalJobs,
    'user': user.toJson(),
  };
}

class User {
  final String name;
  final String? avatarUrl;

  User({
    required this.name,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'avatarUrl': avatarUrl,
  };
}

class JobCount {
  final int images;

  JobCount({required this.images});

  factory JobCount.fromJson(Map<String, dynamic> json) {
    return JobCount(
      images: json['images'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'images': images,
  };
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
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'totalPages': totalPages,
  };
}