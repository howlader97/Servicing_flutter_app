import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/recent_activity_model.dart';
import 'package:flutter_riverpod_template/services/repository/housing_recent_activity_repository.dart';

final housingRecentActivityRepositoryProvider =
    Provider<HousingRecentActivityRepository>((ref) {
  return HousingRecentActivityRepository.instance;
});

final housingRecentActivityProvider =
    FutureProvider.autoDispose<RecentActivityModel?>((ref) async {
  final repository = ref.read(housingRecentActivityRepositoryProvider);
  return repository.getRecentActivity();
});
