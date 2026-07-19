import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/fcm_repository.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class FcmNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> sendTokenToServer(String token) async {
    state = const AsyncValue.loading();
    try {
      final success = await ref
          .read(fcmRepositoryProvider)
          .sendFcmToken(fcmToken: token);
      if (success) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          "Failed to send FCM token",
          StackTrace.current,
        );
      }
    } catch (e, stack) {
      errorLog("sendTokenToServer error", e);
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> retrieveAndSendToken() async {
    final token = await StorageServices.instance.getFcmToken();
    if (token.isNotEmpty) {
      final userToken = await StorageServices.instance.getToken();
      if (userToken.isNotEmpty) {
        await sendTokenToServer(token);
      }
    }
  }
}

final fcmProvider = NotifierProvider<FcmNotifier, AsyncValue<void>>(() {
  return FcmNotifier();
});
