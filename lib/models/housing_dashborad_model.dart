class HousingDashboardModel {
  final bool success;
  final String message;
  final CommunityData data;

  HousingDashboardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HousingDashboardModel.fromJson(Map<String, dynamic> json) {
    return HousingDashboardModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CommunityData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class CommunityData {
  final Jobs jobs;
  final int totalIssues;

  CommunityData({required this.jobs, required this.totalIssues});

  factory CommunityData.fromJson(Map<String, dynamic> json) {
    return CommunityData(
      jobs: Jobs.fromJson(json['jobs'] ?? {}),
      totalIssues: int.tryParse("${json['totalIssues'] ?? 0}") ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'jobs': jobs.toJson(), 'totalIssues': totalIssues};
  }
}

class Jobs {
  final int total;

  Jobs({required this.total});

  factory Jobs.fromJson(Map<String, dynamic> json) {
    return Jobs(total: int.tryParse("${json['total'] ?? 0}") ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'total': total};
  }
}
