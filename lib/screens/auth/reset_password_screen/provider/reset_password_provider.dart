import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/forgot_password_repository.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';

class ResetPasswordNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> reset({
    required String email,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();
    final success = await ForgotPasswordRepository.instance.resetPassword(
      email: email,
      code: code,
      password: password,
      confirmPassword: confirmPassword,
    );
    if (success) {
      AppSnackBar.instance.success("Password reset successfully!");
      state = const AsyncValue.data(true);
      return true;
    } else {
      state = const AsyncValue.data(false);
      return false;
    }
  }
}

final resetPasswordProvider = NotifierProvider<ResetPasswordNotifier, AsyncValue<bool?>>(() {
  return ResetPasswordNotifier();
});
