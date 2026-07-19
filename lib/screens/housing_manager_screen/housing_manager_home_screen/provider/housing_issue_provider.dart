import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/issue_model.dart';
import 'package:flutter_riverpod_template/services/repository/housing_issue_repository.dart';

class HousingIssuesState {
  final List<Issue> issues;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  HousingIssuesState({
    this.issues = const [],
    this.page = 1,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  HousingIssuesState copyWith({
    List<Issue>? issues,
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return HousingIssuesState(
      issues: issues ?? this.issues,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

final housingIssueRepositoryProvider = Provider<HousingIssueRepository>((ref) {
  return HousingIssueRepository.instance;
});

final housingIssueProvider =
    NotifierProvider.autoDispose<HousingIssuesNotifier, HousingIssuesState>(() {
  return HousingIssuesNotifier();
});

class HousingIssuesNotifier extends Notifier<HousingIssuesState> {
  late final HousingIssueRepository _repository;

  @override
  HousingIssuesState build() {
    _repository = ref.read(housingIssueRepositoryProvider);
    Future.microtask(() => fetchNextPage());
    return HousingIssuesState();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final response = await _repository.getHousingIssues(
        page: state.page,
        limit: 10,
      );

      if (response != null && response.success) {
        final newIssues = response.data.issues;
        final currentPage = response.meta.page;
        final totalPages = response.meta.totalPages;

        state = state.copyWith(
          issues: [...state.issues, ...newIssues],
          page: currentPage + 1,
          isLoading: false,
          hasMore: currentPage < totalPages,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
          error: "Failed to fetch issues",
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
    state = HousingIssuesState();
    await fetchNextPage();
  }
}
