import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/property_details_response.dart';
import 'package:flutter_riverpod_template/services/repository/housing_propersity_repository.dart';

final housingMaintenanceProvider = FutureProvider.family.autoDispose<PropertyDetailsResponse?, String>((ref, propertyId) async {
  return HousingPropertyRepository.instance.getPropertyDetails(propertyId);
});
