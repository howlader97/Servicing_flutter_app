import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/contractor_job_model.dart';
import 'package:flutter_riverpod_template/services/repository/contractor_job_repository.dart';

class ContractorJobsState {
  final List<ContractorJob> jobs;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  ContractorJobsState({
    this.jobs = const [],
    this.page = 1,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  ContractorJobsState copyWith({
    List<ContractorJob>? jobs,
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return ContractorJobsState(
      jobs: jobs ?? this.jobs,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

final contractorJobRepositoryProvider = Provider<ContractorJobRepository>((ref) {
  return ContractorJobRepository.instance;
});

final contractorJobsProvider =
    NotifierProvider.autoDispose<ContractorJobsNotifier, ContractorJobsState>(() {
  return ContractorJobsNotifier();
});

class ContractorJobsNotifier extends Notifier<ContractorJobsState> {
  late final ContractorJobRepository _repository;

  @override
  ContractorJobsState build() {
    _repository = ref.read(contractorJobRepositoryProvider);
    Future.microtask(() => fetchNextPage());
    return ContractorJobsState();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final response = await _repository.getContractorJobs(
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
    }
  }

  Future<void> refresh() async {
    state = ContractorJobsState();
    await fetchNextPage();
  }
}
