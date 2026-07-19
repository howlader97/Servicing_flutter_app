import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class ContractorJobEvidenceRepository {
  /////////////// constructor
  ContractorJobEvidenceRepository._privateConstructor();

  static final ContractorJobEvidenceRepository _instance = ContractorJobEvidenceRepository
      ._privateConstructor();

  static ContractorJobEvidenceRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<bool> submitJobEvidence({
    required String description,
    required List<String> photos,
    required String jobId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "notes": description,
      });

      for (var path in photos) {
        if (path.isNotEmpty) {
          final file = File(path);
          if (await file.exists()) {
            String fileName = file.path.split('/').last;
            var mimeType = lookupMimeType(file.path);
            formData.files.add(
              MapEntry(
                "photos",
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: MediaType.parse(mimeType ?? "application/octet-stream"),
                ),
              ),
            );
          }
        }
      }

      var response = await _apiServices.postServices(
        url: _api.jobEvidence(jobId),
        body: formData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("submitJobEvidence repo", e);
    }
    return false;
  }
}