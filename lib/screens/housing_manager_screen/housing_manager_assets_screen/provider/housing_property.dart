import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/models/property_response.dart';
import 'package:flutter_riverpod_template/services/repository/housing_propersity_repository.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

final housingPropertyProvider= StateNotifierProvider.autoDispose<HousingProperty,AsyncValue<PropertyResponse?>>((ref) =>
 HousingProperty());

class HousingProperty extends StateNotifier<AsyncValue<PropertyResponse?>>{
  HousingProperty() :super(const AsyncLoading()){getProperty();}


  Future<void> getProperty()async{
    try{
      state =AsyncLoading();
      final response= await HousingPropertyRepository.instance.getPropertyData();
      if(response != null){
        state =AsyncData(response);
      }else{
        state = AsyncData(null);
      }
    }catch(e){
      errorLog("property data", e);
    }
  }

}