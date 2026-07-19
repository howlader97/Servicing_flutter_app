class ContractorJobModel {
  final bool success;
  final String message;
  final ContractorJobData data;
  final Meta meta;

  ContractorJobModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ContractorJobModel.fromJson(Map<String, dynamic> json) {
    return ContractorJobModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ContractorJobData.fromJson(json['data'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class ContractorJobData {
  final List<ContractorJob> jobs;

  ContractorJobData({
    required this.jobs,
  });

  factory ContractorJobData.fromJson(Map<String, dynamic> json) {
    return ContractorJobData(
      jobs: (json['jobs'] as List<dynamic>? ?? [])
          .map((e) => ContractorJob.fromJson(e))
          .toList(),
    );
  }
}

class ContractorJob {
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
  final DateTime? scheduledDate;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final num estimatedCost;
  final num actualCost;
  final String notes;
  final String tenantName;
  final String tenantPhone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Property property;
  final AssignedTo assignedTo;
  final List<JobImage> images;
  final ImageCount count;

  ContractorJob({
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
    this.scheduledDate,
    this.startedAt,
    this.completedAt,
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

  factory ContractorJob.fromJson(Map<String, dynamic> json) {
    return ContractorJob(
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
          ? DateTime.tryParse(json['scheduledDate'])
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
      estimatedCost: json['estimatedCost'] ?? 0,
      actualCost: json['actualCost'] ?? 0,
      notes: json['notes'] ?? '',
      tenantName: json['tenantName'] ?? '',
      tenantPhone: json['tenantPhone'] ?? '',
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt']) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (DateTime.tryParse(json['updatedAt']) ?? DateTime.now())
          : DateTime.now(),
      property: Property.fromJson(json['property'] ?? {}),
      assignedTo: AssignedTo.fromJson(json['assignedTo'] ?? {}),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => JobImage.fromJson(e))
          .toList(),
      count: ImageCount.fromJson(json['_count'] ?? {}),
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

class AssignedTo {
  final String id;
  final String userId;
  final String companyName;
  final String specialty;
  final String licenseNo;
  final num rating;
  final int totalJobs;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? serviceId;
  final AssignedUser user;

  AssignedTo({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.specialty,
    required this.licenseNo,
    required this.rating,
    required this.totalJobs,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceId,
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
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt']) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (DateTime.tryParse(json['updatedAt']) ?? DateTime.now())
          : DateTime.now(),
      serviceId: json['serviceId'],
      user: AssignedUser.fromJson(json['user'] ?? {}),
    );
  }
}

class AssignedUser {
  final String name;
  final String? avatarUrl;

  AssignedUser({
    required this.name,
    required this.avatarUrl,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) {
    return AssignedUser(
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }
}

class JobImage {
  final String id;
  final String jobId;
  final String imageUrl;
  final String caption;
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
      caption: json['caption'] ?? '',
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt']) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}

class ImageCount {
  final int images;

  ImageCount({
    required this.images,
  });

  factory ImageCount.fromJson(Map<String, dynamic> json) {
    return ImageCount(
      images: json['images'] ?? 0,
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