import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/services/api/non_auth_api.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter_riverpod_template/models/community_name_model.dart';
import 'package:flutter_riverpod_template/models/service_name_model.dart';

class AuthRepository {
  ////////////// Contractures
  AuthRepository._privetContractures();
  static final AuthRepository _instance = AuthRepository._privetContractures();
  static AuthRepository get instance => _instance;

  /////////////// object
  final ApiServices apiServices = ApiServices.instance;
  NonAuthApi nonAuthApi = NonAuthApi();
  AppApiUrl api = AppApiUrl.instance;
  StorageServices storageServices = StorageServices.instance;
  /////////////// function
  Future<bool> login({
    required String email,
    required String password,
    //required String fcmToken, required String deviceId
  }) async {
    try {
      Map<String, String> bodyData = {
        "email": email.trim().toLowerCase(),
        "password": password.trim(),
        // "deviceId": deviceId.trim(),
        // "fcmToken": fcmToken.trim(),
      };

      var response = await nonAuthApi.sendRequest.post(
        api.login,
        data: bodyData,
      );

      if (response.data is Map) {
        final data = response.data["data"];

        if (data is Map) {
          if (data["accessToken"] is String) {
            await storageServices.setToken(
              data["accessToken"].toString(),
            );
          }

          if (data["refreshToken"] is String) {
            await storageServices.setRefreshToken(
              data["refreshToken"].toString(),
            );
          }

          if (data["user"] is Map) {
            final user = data["user"];

            if (user["role"] is String) {
              await storageServices.setAppRoll(
                user["role"].toString(),
              );


            }
          }
        }

        return true;
      }
      
    } catch (e) {
      errorLog("login function repo", e);
    }
    return false;
  }

  Future<bool> accountDelete({required String password}) async {
    try {
      Map<String, String> body = {"password": password};
      var response = await apiServices.deleteServices(url: api.authDeleteAccount, body: body);
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("accountDelete AuthRepository", e);
    }
    return false;
  }

  Future<bool> updateProfile({required String profileImage, required Map<String, String> body}) async {
    try {
      FormData formData = FormData.fromMap(body);
      if (profileImage.isNotEmpty) {
        final file = File(profileImage);
        if (await file.exists()) {
          String fileName = file.path.split('/').last;
          var mimeType = lookupMimeType(file.path);
          formData.files.add(
            MapEntry(
              "profile",
              await MultipartFile.fromFile(file.path, filename: fileName, contentType: MediaType.parse(mimeType ?? "application/octet-stream")),
            ),
          );
        }
      }
      var response = await apiServices.patchServices(url: api.user, body: formData);
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("updateProfile repo", e);
    }
    return false;
  }

  Future<bool> changePassword({required String currentPassword, required String newPassword, required String confirmPassword}) async {
    try {
      Map<String, String> body = {"currentPassword": currentPassword, "newPassword": newPassword, "confirmPassword": confirmPassword};

      var response = await apiServices.postServices(url: api.changePassword, body: body);
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("changePassword repo", e);
    }
    return false;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String role,
    String? communityId,
    String? serviceId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "name": name,
        "email": email.trim().toLowerCase(),
        "phone": phone.trim(),
        "role": role,
        "password": password,
        "confirmPassword": confirmPassword,
      };

      if (role == "HOUSING_MANAGER") {
        body["communityId"] = communityId ?? "";
      }

      if (role == "CONTRACTOR") {
        body["serviceId"] = serviceId ?? "";
      }

      final response = await apiServices.postServices(
        url: api.user,
        body: body,
      );

      return response != null;
    } catch (e) {
      errorLog("signUp repo", e);
      return false;
    }
  }



  Future<bool> authResendOTP({required String email}) async {
    try {
      var response = await apiServices.postServices(url: api.userResendOtp, body: {"email": email});
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("authResendOTP", e);
    }
    return false;
  }

  Future<bool> authOtpVerify({required String email, required String code}) async {
    try {
      Map<String, dynamic> bodyData = {
        "email": email.trim().toLowerCase(),
        "code": code.trim(),
        "type": "EMAIL_VERIFY"
      };
      var response = await apiServices.postServices(url: api.authOtpVerify, body: bodyData);
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("authOtpVerify", e);
    }
    return false;
  }

  ////////// forgot
  Future<bool> forgotPassword({required String email}) async {
    try {
      Map<String, String> bodyData = {"email": email};
      var response = await apiServices.postServices(url: api.authForgotPassword, body: bodyData);
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return false;
  }

  Future<String> forgotVerifyEmail({required String email, required int otp}) async {
    try {
      Map<String, dynamic> bodyData = {"email": email, "oneTimeCode": otp};
      var response = await apiServices.postServices(url: api.authVerifyEmail, body: bodyData);
      if (response != null) {
        if (response["data"] != null && response["data"] is String) {
          return response["data"].toString();
        }
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return "";
  }

  Future<bool> forgotResetPassword({required String token, required String newPassword, required String confirmPassword}) async {
    try {
      Map<String, dynamic> bodyData = {"newPassword": newPassword, "confirmPassword": confirmPassword};
      var response = await nonAuthApi.sendRequest.post(
        api.authResetPassword,
        data: bodyData,
        options: Options(headers: {"Authorization": "Bearer $token", "Content-Type": "application/json", "Accept": "*/*"}),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return false;
  }

  Future<CommunityNameModel?> getCommunities() async {
    try {
      var response = await apiServices.getServices(api.userCommunity);
      if (response != null) {
        return CommunityNameModel.fromJson(response);
      }
    } catch (e) {
      errorLog("getCommunities repo", e);
    }
    return null;
  }

  Future<ServiceNameModel?> getServicesList() async {
    try {
      var response = await apiServices.getServices(api.userService);
      if (response != null) {
        return ServiceNameModel.fromJson(response);
      }
    } catch (e) {
      errorLog("getServicesList repo", e);
    }
    return null;
  }
}
