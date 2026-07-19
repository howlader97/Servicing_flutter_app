import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/housing_dashborad_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class HousingHomeRepository {
  /////////////// constructor
  HousingHomeRepository._privateConstructor();

  static final HousingHomeRepository _instance =
      HousingHomeRepository._privateConstructor();

  static HousingHomeRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<HousingDashboardModel?> getDashBoard() async {
    try {
      final response = await _apiServices.getServices(_api.housingDashboard);
      if (response != null) {
        return HousingDashboardModel.fromJson(response);
      }
    } catch (e) {
      errorLog("housing dashBoard is", e);
    }
    return null;
  }
}
