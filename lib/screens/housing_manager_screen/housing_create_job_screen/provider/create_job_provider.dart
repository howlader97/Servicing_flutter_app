import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/models/service_name_model.dart';
import 'package:flutter_riverpod_template/models/all_contractors_model.dart';
import 'package:flutter_riverpod_template/models/property_response.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/navigation_provider.dart';
import 'package:flutter_riverpod_template/services/repository/housing_job_repository.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_job_screen/provider/job_provider.dart';


final jobCategoryProvider = StateProvider.autoDispose<ServiceCategory?>(
  (ref) => null,
);


final jobAssigneeProvider = StateProvider.autoDispose<Contractor?>(
  (ref) => null,
);

final jobPriorityProvider = StateProvider.autoDispose<String>(
  (ref) => 'URGENT',
);

final jobPropertyProvider = StateProvider.autoDispose<Property?>((ref) => null);


class CreateJobNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() => const AsyncValue.data(null);

  Future<void> submit({
    required String title,
    required String description,
    required String propertyId,
    required String issueId,
    required String priority,
    String? assignedToId,
    required String tenantName,
    required String tenantPhone,
    required List<String> photos,
  }) async {
    state = const AsyncValue.loading();

    final success = await HousingJobRepository.instance.createJob(
      title: title,
      description: description,
      propertyId: propertyId,
      issueId: issueId,
      priority: priority,
      assignedToId: assignedToId,
      tenantName: tenantName,
      tenantPhone: tenantPhone,
      photos: photos,
    );

    if (success) {
      AppSnackBar.instance.success('Job created successfully!');
      state = const AsyncValue.data(true);

      ref.invalidate(jobProvider);
      ref.read(navigationProvider.notifier).state = 1;
      AppRoutes.instance.goNamed(
        AppRoutesKey.instance.appNavigationScreen,
      );
    } else {
      state = const AsyncValue.data(false);
      AppSnackBar.instance.error('Failed to create job. Please try again.');
    }
  }
}

final createJobProvider =
    NotifierProvider<CreateJobNotifier, AsyncValue<bool?>>(() {
  return CreateJobNotifier();
});
