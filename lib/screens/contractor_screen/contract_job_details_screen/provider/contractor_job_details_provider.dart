import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/contractor_job_model.dart';
import 'package:flutter_riverpod_template/services/repository/contractor_job_repository.dart';

final contractorJobDetailsProvider =
    FutureProvider.autoDispose.family<ContractorJob?, String>((ref, jobId) async {
  return ContractorJobRepository.instance.getContractorJobDetails(jobId);
});
