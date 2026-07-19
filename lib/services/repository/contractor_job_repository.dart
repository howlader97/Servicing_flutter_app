import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/contractor_job_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class ContractorJobRepository {
  /////////////// constructor
  ContractorJobRepository._privateConstructor();

  static final ContractorJobRepository _instance =
      ContractorJobRepository._privateConstructor();

  static ContractorJobRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<ContractorJobModel?> getContractorJobs({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiServices.getServices(
        _api.contractorJobs,
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );
      if (response != null) {
        if (response['data'] != null && response['success'] == true) {
          return ContractorJobModel.fromJson(response);
        }
      }
    } catch (e) {
      errorLog("contractor jobs repo error", e);
    }
    return null;
  }

  Future<ContractorJob?> getContractorJobDetails(String jobId) async {
    try {
      final response = await _apiServices.getServices(
        _api.contractorJobDetails(jobId),
      );
      if (response != null) {
        if (response['data'] != null && response['success'] == true) {
          final jobData = response['data']['job'] ?? response['data'];
          return ContractorJob.fromJson(jobData);
        }
      }
    } catch (e) {
      errorLog("contractor job detail error", e);
    }
    return null;
  }

  Future<bool> acceptJob(String jobId) async {
    try {
      final response = await _apiServices.putServices(
        url: _api.contractorAcceptJob(jobId),
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("acceptJob repo error", e);
    }
    return false;
  }

  Future<bool> declineJob(String jobId) async {
    try {
      final response = await _apiServices.putServices(
        url: _api.contractorDeclineJob(jobId),
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("declineJob repo error", e);
    }
    return false;
  }
}
