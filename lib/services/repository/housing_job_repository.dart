import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/all_jobs_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class HousingJobRepository {
  /////////////// constructor
  HousingJobRepository._privateConstructor();

  static final HousingJobRepository _instance = HousingJobRepository
      ._privateConstructor();

  static HousingJobRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<AllJobsModel?> getAllJObsData({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiServices.getServices(
        _api.housingJobs,
        queryParameters: {"page": page, "limit": limit},
      );
      if (response != null) {
        if (response['data'] != null && response['success'] == true) {
          return AllJobsModel.fromJson(response);
        }
      }
    } catch (e) {
      errorLog("housing dashBoard is", e);
    }
    return null;
  }

  Future<Job?> getJobDetails(String jobId)async{
    try{
      final response = await _apiServices.getServices(_api.jobDetails(jobId));
      if(response != null){
        if(response['data'] != null && response['success'] == true){
          final jobData = response['data']['job'] ?? response['data'];
          return Job.fromJson(jobData);
        }
      }
    }catch(e){
      errorLog("housing dashBoard is", e);
    }
    return null;
  }

  Future<bool> approveJob(String jobId) async {
    try {
      final response = await _apiServices.putServices(
        url: _api.approveJob(jobId),
      );
      return response != null;
    } catch (e) {
      errorLog("approveJob error", e);
      return false;
    }
  }

  Future<bool> rejectJob(String jobId) async {
    try {
      final response = await _apiServices.putServices(
        url: _api.rejectJob(jobId),
      );
      return response != null;
    } catch (e) {
      errorLog("rejectJob error", e);
      return false;
    }
  }

  Future<bool> submitJobReview({
    required String jobId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.reviewJob(jobId),
        body: {
          "rating": rating,
          "comment": comment,
        },
      );
      return response != null;
    } catch (e) {
      errorLog("submitJobReview error", e);
      return false;
    }
  }

  Future<bool> assignJob({
    required String jobId,
    required String contractorId,
  }) async {
    try {
      final response = await _apiServices.putServices(
        url: _api.assignJob(jobId),
        body: {
          "contractorId": contractorId,
        },
      );
      return response != null;
    } catch (e) {
      errorLog("assignJob error", e);
      return false;
    }
  }


  Future<bool> createJob({
    required String title,
    required String description,
    required String propertyId,
    required String issueId,
    required String priority,
    String? assignedToId,
    required String tenantName,
    required String tenantPhone,
    required List<String> photos,
  }) async {
    try {
      final List<MultipartFile> photoFiles = await Future.wait(
        photos.map(
          (path) => MultipartFile.fromFile(
            path,
            filename: path.split(Platform.pathSeparator).last,
          ),
        ),
      );

      final Map<String, dynamic> fields = {
        'title': title,
        'description': description,
        'propertyId': propertyId,
        'issueCategoryId': issueId,
        'priority': priority,
        'tenantName': tenantName,
        'tenantPhone': tenantPhone,
        'photos': photoFiles,
      };


      if (assignedToId != null && assignedToId.isNotEmpty) {
        fields['assignedToId'] = assignedToId;
      }

      final response = await _apiServices.postServices(
        url: _api.housingJobs,
        body: FormData.fromMap(fields),
      );

      return response != null;
    } catch (e) {
      errorLog('createJob error', e);
      return false;
    }
  }
}