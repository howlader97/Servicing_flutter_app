
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/user_profile.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ProfileRepository {
  /////////////// constructor
  ProfileRepository._privateConstructor();

  static final ProfileRepository _instance = ProfileRepository._privateConstructor();

  static ProfileRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<ProfileModel?> getUserProfile() async {
    try {
      final response = await _apiServices.getServices(_api.profile);
      if (response != null) {
        if (response['data'] != null && response['success'] == true) {
          return ProfileModel.fromJson(response);
        }
      }
    } catch (e) {
      errorLog("getUserProfile error is", e);
    }
    return null;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Map<String, String> body = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final response = await _apiServices.putServices(url: _api.changePassword, body: body);
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("changePassword error is", e);
    }
    return false;
  }

  Future<bool> uploadAvatar(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return false;
      }
      String fileName = file.path.split('/').last;
      var mimeType = lookupMimeType(file.path);

      FormData formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType ?? "application/octet-stream"),
        ),
      });

      final response = await _apiServices.postServices(
        url: "/profile/avatar",
        body: formData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("uploadAvatar error is", e);
    }
    return false;
  }

  Future<bool> updateProfileDetails({required String name, String? serviceId}) async {
    try {
      Map<String, dynamic> body = {
        "name": name,
      };
      if (serviceId != null) {
        body["serviceId"] = serviceId;
      }

      final response = await _apiServices.putServices(
        url: _api.profile,
        body: body,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("updateProfileDetails error is", e);
    }
    return false;
  }
}