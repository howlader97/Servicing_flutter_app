import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/property_details_response.dart';
import 'package:flutter_riverpod_template/models/property_response.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class HousingPropertyRepository {
  /////////////// constructor
  HousingPropertyRepository._privateConstructor();

  static final HousingPropertyRepository _instance = HousingPropertyRepository
      ._privateConstructor();

  static HousingPropertyRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<PropertyResponse?> getPropertyData()async{
    try{
      final response = await _apiServices.getServices(_api.housingProperty);
      if(response != null){
       if(response['data'] != null && response['success'] == true){
         return PropertyResponse.fromJson(response);
       }
      }
    }catch(e){
      errorLog("housing dashBoard is", e);
    }
    return null;
  }

  Future<PropertyDetailsResponse?> getPropertyDetails(String propertyId) async {
    try {
      final response = await _apiServices.getServices(_api.housingPropertyDetails(propertyId));
      if (response != null) {
        if (response['data'] != null && response['success'] == true) {
          return PropertyDetailsResponse.fromJson(response);
        }
      }
    } catch (e) {
      errorLog("housing property details error", e);
    }
    return null;
  }
}