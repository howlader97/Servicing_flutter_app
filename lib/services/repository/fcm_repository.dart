import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class FcmRepository {
  FcmRepository._privateConstructor();

  static final FcmRepository _instance = FcmRepository._privateConstructor();

  static FcmRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<bool> sendFcmToken({required String fcmToken}) async {
    try {
      print("Sending FCM Token to backend...");
      final response = await _apiServices.putServices(
        url: _api.fcmToken,
        body: {"fcmToken":fcmToken},
      );
      if (response != null) {
        print("FCM Token synced with backend successfully!");
        return true;
      } else {
        print(" Failed to sync FCM Token with backend (Response was null).");
        return false;
      }
    } catch (e) {
      errorLog("sendFcmToken error", e);
      print(" Failed to sync FCM Token with backend: $e");
      return false;
    }
  }
}

final fcmRepositoryProvider = Provider<FcmRepository>((ref) {
  return FcmRepository.instance;
});
