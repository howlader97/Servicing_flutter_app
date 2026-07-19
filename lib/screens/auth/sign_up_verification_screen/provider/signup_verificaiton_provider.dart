import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/repository/auth_repository.dart';

class SignUpOtpVerifyNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> verifyOtp({required String email, required String code}) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      return await AuthRepository.instance.authOtpVerify(email: email, code: code);
    });
    state = result;
  }
}

final signUpOtpVerifyProvider = NotifierProvider<SignUpOtpVerifyNotifier, AsyncValue<bool?>>(() {
  return SignUpOtpVerifyNotifier();
});

/// Notifier to handle Resending OTP
class SignUpResendOtpNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> resendOtp({required String email}) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      return await AuthRepository.instance.authResendOTP(email: email);
    });
    state = result;
  }
}

final signUpResendOtpProvider = NotifierProvider<SignUpResendOtpNotifier, AsyncValue<bool?>>(() {
  return SignUpResendOtpNotifier();
});
