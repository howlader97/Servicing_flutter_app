import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/recent_activity_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class HousingRecentActivityRepository {
  /////////////// constructor
  HousingRecentActivityRepository._privateConstructor();

  static final HousingRecentActivityRepository _instance =
      HousingRecentActivityRepository._privateConstructor();

  static HousingRecentActivityRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<RecentActivityModel?> getRecentActivity() async {
    try {
      final response = await _apiServices.getServices(_api.housingRecentActivity);
      if (response != null) {
        return RecentActivityModel.fromJson(response);
      }
    } catch (e) {
      errorLog("housing recent activity repo error", e);
    }
    return null;
  }
}
