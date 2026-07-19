import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class ForgotPasswordRepository {
  ForgotPasswordRepository._privateConstructor();

  static final ForgotPasswordRepository _instance = ForgotPasswordRepository._privateConstructor();

  static ForgotPasswordRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<bool> forgotPassword({required String email}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.forgotPassword,
        body: {"email": email},
      );
      return response != null;
    } catch (e) {
      errorLog("forgotPassword error", e);
      return false;
    }
  }

  Future<bool> verifyOtp({required String email, required String code}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.verifyEmail,
        body: {
          "email": email,
          "code": code,
          "type": "EMAIL_VERIFY",
        },
      );
      return response != null;
    } catch (e) {
      errorLog("verifyOtp error", e);
      return false;
    }
  }

  Future<bool> resendOtp({required String email}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.resendVerification,
        body: {"email": email},
      );
      return response != null;
    } catch (e) {
      errorLog("resendOtp error", e);
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.resetPassword,
        body: {
          "email": email,
          "code": code,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );
      return response != null;
    } catch (e) {
      errorLog("resetPassword error", e);
      return false;
    }
  }
}
