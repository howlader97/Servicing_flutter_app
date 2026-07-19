import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/contractor_job_evidence_repository.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';

final contractorJobEvidenceRepositoryProvider =
    Provider<ContractorJobEvidenceRepository>((ref) {
  return ContractorJobEvidenceRepository.instance;
});

class ContractJobEvidenceNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> submit({
    required String jobId,
    required String description,
    required List<String> photos,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(contractorJobEvidenceRepositoryProvider);
      final success = await repository.submitJobEvidence(
        description: description,
        photos: photos,
        jobId: jobId,
      );
      if (success) {
        AppSnackBar.instance.success("Job evidence submitted successfully!");
        AppRoutes.instance.pushReplacement(AppRoutesKey.instance.contractJobSuccess);
      } else {
        AppSnackBar.instance.error("Failed to submit job evidence");
      }
      return success;
    });
    state = result;
  }
}

final contractJobEvidenceProvider =
    NotifierProvider<ContractJobEvidenceNotifier, AsyncValue<bool?>>(() {
  return ContractJobEvidenceNotifier();
});
