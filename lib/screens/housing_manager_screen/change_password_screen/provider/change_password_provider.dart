import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/profile_repository.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';

class ChangePasswordNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();
    final success = await ProfileRepository.instance.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if (success) {
      AppSnackBar.instance.success("Password changed successfully!");
      state = const AsyncValue.data(true);
      AppRoutes.instance.pop();
      return true;
    } else {
      AppSnackBar.instance.error("Password changed failed!");
      state = const AsyncValue.data(false);
      return false;
    }
  }
}

final changePasswordProvider =
    NotifierProvider<ChangePasswordNotifier, AsyncValue<bool?>>(() {
  return ChangePasswordNotifier();
});
