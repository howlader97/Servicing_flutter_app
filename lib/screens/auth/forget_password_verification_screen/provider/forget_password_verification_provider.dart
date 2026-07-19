import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/services/repository/forgot_password_repository.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';

final forgotPasswordOtpProvider = StateProvider<String>((ref) => "");

class ForgetPasswordVerificationNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> verify(String email, String code) async {
    state = const AsyncValue.loading();
    final success = await ForgotPasswordRepository.instance.verifyOtp(email: email, code: code);
    if (success) {
      ref.read(forgotPasswordOtpProvider.notifier).state = code;
      AppSnackBar.instance.success("OTP verified successfully!");
      state = const AsyncValue.data(true);
      return true;
    } else {
      state = const AsyncValue.data(false);
      return false;
    }
  }
}

final forgetPasswordVerificationProvider = NotifierProvider<ForgetPasswordVerificationNotifier, AsyncValue<bool?>>(() {
  return ForgetPasswordVerificationNotifier();
});

class ForgetPasswordResendOtpNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> resend(String email) async {
    state = const AsyncValue.loading();
    final success = await ForgotPasswordRepository.instance.resendOtp(email: email);
    if (success) {
      AppSnackBar.instance.success("Verification code resent successfully!");
      state = const AsyncValue.data(true);
      return true;
    } else {
      state = const AsyncValue.data(false);
      return false;
    }
  }
}

final forgetPasswordResendOtpProvider = NotifierProvider<ForgetPasswordResendOtpNotifier, AsyncValue<bool?>>(() {
  return ForgetPasswordResendOtpNotifier();
});
