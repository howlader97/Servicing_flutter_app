import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/models/all_contractors_model.dart';
import 'package:flutter_riverpod_template/services/repository/housing_contractor_repository.dart';

class HousingContractorsState {
  final List<Contractor> contractors;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  HousingContractorsState({
    this.contractors = const [],
    this.page = 1,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  HousingContractorsState copyWith({
    List<Contractor>? contractors,
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return HousingContractorsState(
      contractors: contractors ?? this.contractors,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

final housingContractorRepositoryProvider =
    Provider<HousingContractorRepository>((ref) {
  return HousingContractorRepository.instance;
});

final housingContractorProvider = StateNotifierProvider.autoDispose<
    HousingContractorNotifier, HousingContractorsState>((ref) {
  return HousingContractorNotifier(ref);
});

class HousingContractorNotifier extends StateNotifier<HousingContractorsState> {
  final Ref _ref;
  HousingContractorNotifier(this._ref) : super(HousingContractorsState()) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final repository = _ref.read(housingContractorRepositoryProvider);
      final response = await repository.getContractors(
        page: state.page,
        limit: 10,
      );

      if (response != null && response.success) {
        final newContractors = response.data.contractors;
        final currentPage = response.meta.page;
        final totalPages = response.meta.totalPages;

        state = state.copyWith(
          contractors: [...state.contractors, ...newContractors],
          page: currentPage + 1,
          isLoading: false,
          hasMore: currentPage < totalPages,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
          error: "Failed to fetch contractors",
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
    state = HousingContractorsState();
    await fetchNextPage();
  }
}
