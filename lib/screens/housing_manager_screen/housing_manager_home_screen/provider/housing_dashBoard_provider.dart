
import 'package:flutter_riverpod_template/models/housing_dashborad_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/repository/housing_home_repository.dart';

final housingHomeRepositoryProvider =
Provider<HousingHomeRepository>((ref) {
  return HousingHomeRepository.instance;
});

final housingDashBoardProvider =
FutureProvider.autoDispose<HousingDashboardModel?>((ref) async {
  final repository = ref.read(housingHomeRepositoryProvider);
  return repository.getDashBoard();
});