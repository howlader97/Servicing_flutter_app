import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/issue_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class HousingIssueRepository {
  /////////////// constructor
  HousingIssueRepository._privateConstructor();

  static final HousingIssueRepository _instance = HousingIssueRepository
      ._privateConstructor();

  static HousingIssueRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<IssueModel?> getHousingIssues({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiServices.getServices(
        _api.housingIssues,
        queryParameters: {"page": page, "limit": limit},
      );
      if (response != null) {
        if (response['data'] != null && response['success'] == true) {
          return IssueModel.fromJson(response);
        }
      }
    } catch (e) {
      errorLog("getHousingIssues error is", e);
    }
    return null;
  }

  Future<Issue?> getIssueDetails(String issueId) async {
    try {
      final response = await _apiServices.getServices("${_api.housingIssues}/$issueId");
      if (response != null) {
        if (response['data'] != null && response['success'] == true && response['data']['issue'] != null) {
          return Issue.fromJson(response['data']['issue']);
        }
      }
    } catch (e) {
      errorLog("Issue Details error is", e);
    }
    return null;
  }
}
