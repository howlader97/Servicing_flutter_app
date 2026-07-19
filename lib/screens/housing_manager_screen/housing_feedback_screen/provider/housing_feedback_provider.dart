import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/housing_job_repository.dart';

class HousingFeedbackState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  HousingFeedbackState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  HousingFeedbackState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return HousingFeedbackState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

final housingFeedbackProvider = NotifierProvider.autoDispose<
    HousingFeedbackNotifier, HousingFeedbackState>(() {
  return HousingFeedbackNotifier();
});

class HousingFeedbackNotifier extends Notifier<HousingFeedbackState> {
  @override
  HousingFeedbackState build() {
    return HousingFeedbackState();
  }

  Future<bool> submitFeedback({
    required String jobId,
    required int rating,
    required String comment,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await HousingJobRepository.instance.submitJobReview(
        jobId: jobId,
        rating: rating,
        comment: comment,
      );
      if (success) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: "Failed to submit review");
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
