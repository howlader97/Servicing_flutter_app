import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/community_name_model.dart';
import 'package:flutter_riverpod_template/models/service_name_model.dart';
import 'package:flutter_riverpod_template/services/repository/auth_repository.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';

/// Provider to fetch communities list
class CommunitiesNotifier extends AsyncNotifier<List<Community>> {
  @override
  Future<List<Community>> build() async {
    final response = await AuthRepository.instance.getCommunities();
    return response?.data ?? [];
  }
}

final communitiesProvider = AsyncNotifierProvider<CommunitiesNotifier, List<Community>>(() {
  return CommunitiesNotifier();
});

/// Provider to fetch services list
class ServicesNotifier extends AsyncNotifier<List<ServiceCategory>> {
  @override
  Future<List<ServiceCategory>> build() async {
    final response = await AuthRepository.instance.getServicesList();
    return response?.data ?? [];
  }
}

final servicesProvider = AsyncNotifierProvider<ServicesNotifier, List<ServiceCategory>>(() {
  return ServicesNotifier();
});

/// State providers to hold selected dropdown values
class SelectedCommunityNotifier extends Notifier<Community?> {
  @override
  Community? build() => null;

  void select(Community? val) {
    state = val;
  }
}

final selectedCommunityProvider = NotifierProvider<SelectedCommunityNotifier, Community?>(() {
  return SelectedCommunityNotifier();
});

class SelectedServiceNotifier extends Notifier<ServiceCategory?> {
  @override
  ServiceCategory? build() => null;

  void select(ServiceCategory? val) {
    state = val;
  }
}

final selectedServiceProvider = NotifierProvider<SelectedServiceNotifier, ServiceCategory?>(() {
  return SelectedServiceNotifier();
});

/// Notifier to handle the sign up request state
class SignUpActionNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String role,
    String? communityId,
    String? serviceId,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final success = await AuthRepository.instance.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        role: role,
        communityId: communityId,
        serviceId: serviceId,
      );
      if (success) {
        await StorageServices.instance.setEmail(email);
      }
      return success;
    });
    state = result;
  }
}

final signUpActionProvider = NotifierProvider<SignUpActionNotifier, AsyncValue<bool?>>(() {
  return SignUpActionNotifier();
});


