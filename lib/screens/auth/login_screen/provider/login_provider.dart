import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/auth_repository.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/screens/auth/login_screen/provider/fcm_provider.dart';

import '../../../../services/storage/storage_services.dart';
import '../../../app_navigation_screen/provider/user_role_provider.dart';

class LoginActionNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final success = await AuthRepository.instance.login(
        email: email,
        password: password,
      );
      if (success) {
        final role = await StorageServices.instance.getAppRoll();
        ref.read(userRoleProvider.notifier).setRole(role);
        ref.read(fcmProvider.notifier).retrieveAndSendToken();
        AppSnackBar.instance.success("Login successful!");
        AppRoutes.instance.go(AppRoutesKey.instance.appNavigationScreen);
      } else {
        AppSnackBar.instance.error("Invalid email or password");
      }
      return success;
    });
    state = result;
  }
}

final loginActionProvider =
    NotifierProvider<LoginActionNotifier, AsyncValue<bool?>>(() {
      return LoginActionNotifier();
    });
