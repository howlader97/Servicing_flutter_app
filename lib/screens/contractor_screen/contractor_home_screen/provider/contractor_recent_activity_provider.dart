import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/recent_activity_model.dart';
import 'package:flutter_riverpod_template/services/repository/contractor_recent_activity_repository.dart';

final contractorRecentActivityRepositoryProvider =
    Provider<ContractorRecentActivityRepository>((ref) {
  return ContractorRecentActivityRepository.instance;
});

final contractorRecentActivityProvider =
    FutureProvider.autoDispose<RecentActivityModel?>((ref) async {
  final repository = ref.read(contractorRecentActivityRepositoryProvider);
  return repository.getRecentActivity();
});
