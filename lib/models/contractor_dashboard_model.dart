class ContractorDashBoardModel {
  final bool success;
  final String message;
  final DashboardData data;

  ContractorDashBoardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorDashBoardModel.fromJson(Map<String, dynamic> json) {
    return ContractorDashBoardModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DashboardData.fromJson(json['data'] ?? {}),
    );
  }
}

class DashboardData {
  final JobStats jobs;
  final int rating;
  final int totalJobs;

  DashboardData({
    required this.jobs,
    required this.rating,
    required this.totalJobs,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      jobs: JobStats.fromJson(json['jobs'] ?? {}),
      rating: json['rating'] ?? 0,
      totalJobs: json['totalJobs'] ?? 0,
    );
  }
}

class JobStats {
  final int total;
  final int pendingApproval;

  JobStats({
    required this.total,
    required this.pendingApproval,
  });

  factory JobStats.fromJson(Map<String, dynamic> json) {
    return JobStats(
      total: json['total'] ?? 0,
      pendingApproval: json['PENDING_APPROVAL'] ?? 0,
    );
  }
}