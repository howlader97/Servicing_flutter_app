import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/contractor_job_repository.dart';

enum JobActionStatus { idle, acceptLoading, declineLoading }

class ContractorJobActionState {
  final JobActionStatus status;

  const ContractorJobActionState({this.status = JobActionStatus.idle});

  bool get isAcceptLoading => status == JobActionStatus.acceptLoading;
  bool get isDeclineLoading => status == JobActionStatus.declineLoading;
  bool get isIdle => status == JobActionStatus.idle;
}

class ContractorJobActionNotifier
    extends Notifier<ContractorJobActionState> {
  @override
  ContractorJobActionState build() {
    return const ContractorJobActionState();
  }

  Future<bool> acceptJob(String jobId) async {
    if (!state.isIdle) return false;
    final keepAliveLink = ref.keepAlive();
    try {
      state = const ContractorJobActionState(status: JobActionStatus.acceptLoading);
      final success = await ContractorJobRepository.instance.acceptJob(jobId);
      state = const ContractorJobActionState();
      return success;
    } finally {
      keepAliveLink.close();
    }
  }

  Future<bool> declineJob(String jobId) async {
    if (!state.isIdle) return false;
    final keepAliveLink = ref.keepAlive();
    try {
      state = const ContractorJobActionState(
          status: JobActionStatus.declineLoading);
      final success = await ContractorJobRepository.instance.declineJob(jobId);
      state = const ContractorJobActionState();
      return success;
    } finally {
      keepAliveLink.close();
    }
  }
}

final contractorJobActionProvider = NotifierProvider.autoDispose<
    ContractorJobActionNotifier, ContractorJobActionState>(
  ContractorJobActionNotifier.new,
);
