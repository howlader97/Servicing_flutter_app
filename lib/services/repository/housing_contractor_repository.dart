import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/all_contractors_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class HousingContractorRepository {
  /////////////// constructor
  HousingContractorRepository._privateConstructor();

  static final HousingContractorRepository _instance =
      HousingContractorRepository._privateConstructor();

  static HousingContractorRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<AllContractorsModel?> getContractors({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiServices.getServices(
        _api.housingContractors,
        queryParameters: {"page": page, "limit": limit},
      );
      if (response != null) {
        if (response['data'] != null && response['success'] == true) {
          return AllContractorsModel.fromJson(response);
        }
      }
    } catch (e) {
      errorLog("getContractors error is", e);
    }
    return null;
  }
}
