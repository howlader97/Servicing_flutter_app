import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/housing_job_repository.dart';

class HousingJobDetailsState {
  final bool isApproving;
  final bool isRejecting;
  final String? assigningContractorId;
  final String? error;
  final bool isSuccess;

  HousingJobDetailsState({
    this.isApproving = false,
    this.isRejecting = false,
    this.assigningContractorId,
    this.error,
    this.isSuccess = false,
  });

  HousingJobDetailsState copyWith({
    bool? isApproving,
    bool? isRejecting,
    String? assigningContractorId,
    bool clearAssigningState = false,
    String? error,
    bool? isSuccess,
  }) {
    return HousingJobDetailsState(
      isApproving: isApproving ?? this.isApproving,
      isRejecting: isRejecting ?? this.isRejecting,
      assigningContractorId: clearAssigningState ? null : (assigningContractorId ?? this.assigningContractorId),
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

final housingJobDetailsProvider = NotifierProvider.autoDispose<
    HousingJobDetailsNotifier, HousingJobDetailsState>(() {
  return HousingJobDetailsNotifier();
});

class HousingJobDetailsNotifier extends Notifier<HousingJobDetailsState> {
  @override
  HousingJobDetailsState build() {
    return HousingJobDetailsState();
  }

  Future<bool> approveJob(String jobId) async {
    state = state.copyWith(isApproving: true);
    try {
      final success = await HousingJobRepository.instance.approveJob(jobId);
      if (success) {
        state = state.copyWith(isApproving: false, isSuccess: true);
        return true;
      } else {
        state = state.copyWith(isApproving: false, error: "Failed to approve job");
        return false;
      }
    } catch (e) {
      state = state.copyWith(isApproving: false, error: e.toString());
      return false;
    }
  }

  Future<bool> rejectJob(String jobId) async {
    state = state.copyWith(isRejecting: true);
    try {
      final success = await HousingJobRepository.instance.rejectJob(jobId);
      if (success) {
        state = state.copyWith(isRejecting: false, isSuccess: true);
        return true;
      } else {
        state = state.copyWith(isRejecting: false, error: "Failed to reject job");
        return false;
      }
    } catch (e) {
      state = state.copyWith(isRejecting: false, error: e.toString());
      return false;
    }
  }

  Future<bool> assignJob({
    required String jobId,
    required String contractorId,
  }) async {
    state = state.copyWith(assigningContractorId: contractorId);
    try {
      final success = await HousingJobRepository.instance.assignJob(
        jobId: jobId,
        contractorId: contractorId,
      );
      if (success) {
        state = state.copyWith(clearAssigningState: true, isSuccess: true);
        return true;
      } else {
        state = state.copyWith(clearAssigningState: true, error: "Failed to assign contractor");
        return false;
      }
    } catch (e) {
      state = state.copyWith(clearAssigningState: true, error: e.toString());
      return false;
    }
  }
}
