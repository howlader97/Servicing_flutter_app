import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/models/all_jobs_model.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import '../../../../services/repository/housing_job_repository.dart';

class HousingJobsState {
  final List<Job> jobs;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  HousingJobsState({
    this.jobs = const [],
    this.page = 1,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  HousingJobsState copyWith({
    List<Job>? jobs,
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return HousingJobsState(
      jobs: jobs ?? this.jobs,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

final jobProvider =
    StateNotifierProvider.autoDispose<JobNotifier, HousingJobsState>(
      (ref) => JobNotifier(),
    );

class JobNotifier extends StateNotifier<HousingJobsState> {
  JobNotifier() : super(HousingJobsState()) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final response = await HousingJobRepository.instance.getAllJObsData(
        page: state.page,
        limit: 10,
      );

      if (response != null && response.success) {
        final newJobs = response.data.jobs;
        final currentPage = response.meta.page;
        final totalPages = response.meta.totalPages;

        state = state.copyWith(
          jobs: [...state.jobs, ...newJobs],
          page: currentPage + 1,
          isLoading: false,
          hasMore: currentPage < totalPages,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
          error: "Failed to fetch jobs",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      errorLog("fetchNextPage error is", e);
    }
  }

  Future<void> refresh() async {
    state = HousingJobsState();
    await fetchNextPage();
  }
}
