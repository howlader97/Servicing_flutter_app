import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';

class UserRoleNotifier extends Notifier<String> {
  @override
  String build() {
    _loadRole();
    return "";
  }

  Future<void> _loadRole() async {
    final role = await StorageServices.instance.getAppRoll();
    state = role;
  }

  void setRole(String role) {
    state = role;
    StorageServices.instance.setAppRoll(role);
  }
}

final userRoleProvider = NotifierProvider<UserRoleNotifier, String>(() {
  return UserRoleNotifier();
});

