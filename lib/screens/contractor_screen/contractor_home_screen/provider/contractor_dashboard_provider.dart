import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/contractor_dashboard_model.dart';
import 'package:flutter_riverpod_template/services/repository/contractor_repository.dart';

final contractorRepositoryProvider = Provider<ContractorRepository>((ref) {
  return ContractorRepository.instance;
});

final contractorDashboardProvider =
    FutureProvider.autoDispose<ContractorDashBoardModel?>((ref) async {
  final repository = ref.read(contractorRepositoryProvider);
  return repository.getDashboard();
});
