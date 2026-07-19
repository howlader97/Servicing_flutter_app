import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/contractor_dashboard_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class ContractorRepository {
  /////////////// constructor
  ContractorRepository._privateConstructor();

  static final ContractorRepository _instance =
      ContractorRepository._privateConstructor();

  static ContractorRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<ContractorDashBoardModel?> getDashboard() async {
    try {
      final response = await _apiServices.getServices(_api.contractorDashboard);
      if (response != null) {
        return ContractorDashBoardModel.fromJson(response);
      }
    } catch (e) {
      errorLog("contractor dashBoard is", e);
    }
    return null;
  }
}
