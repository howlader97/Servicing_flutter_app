import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/services/repository/forgot_password_repository.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';

final forgotPasswordEmailProvider = StateProvider<String>((ref) => "");

class ForgotPasswordNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> sendCode(String email) async {
    state = const AsyncValue.loading();
    final success = await ForgotPasswordRepository.instance.forgotPassword(email: email);
    if (success) {
      ref.read(forgotPasswordEmailProvider.notifier).state = email;
      AppSnackBar.instance.success("Verification code sent successfully!");
      state = const AsyncValue.data(true);
      return true;
    } else {
      state = const AsyncValue.data(false);
      return false;
    }
  }
}

final forgotPasswordProvider = NotifierProvider<ForgotPasswordNotifier, AsyncValue<bool?>>(() {
  return ForgotPasswordNotifier();
});
