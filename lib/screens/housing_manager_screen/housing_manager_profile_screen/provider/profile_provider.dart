import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/models/user_profile.dart';
import 'package:flutter_riverpod_template/services/repository/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository.instance;
});

final profileProvider = FutureProvider.autoDispose<ProfileModel?>((ref) async {
  final repository = ref.read(profileRepositoryProvider);
  return repository.getUserProfile();
});

enum AvatarUploadStatus { idle, loading, success, error }

class AvatarUploadState {
  final AvatarUploadStatus status;
  final String? errorMessage;

  const AvatarUploadState({
    this.status = AvatarUploadStatus.idle,
    this.errorMessage,
  });

  bool get isLoading => status == AvatarUploadStatus.loading;
  bool get isSuccess => status == AvatarUploadStatus.success;
  bool get isError => status == AvatarUploadStatus.error;
}

class AvatarUploadNotifier extends Notifier<AvatarUploadState> {
  @override
  AvatarUploadState build() {
    return const AvatarUploadState();
  }

  Future<bool> upload(String filePath) async {
    final keepAliveLink = ref.keepAlive();
    try {
      state = const AvatarUploadState(status: AvatarUploadStatus.loading);
      final repo = ref.read(profileRepositoryProvider);
      final success = await repo.uploadAvatar(filePath);
      if (success) {
        state = const AvatarUploadState(status: AvatarUploadStatus.success);
        ref.invalidate(profileProvider);
        return true;
      } else {
        state = const AvatarUploadState(
          status: AvatarUploadStatus.error,
          errorMessage: "Failed to upload avatar",
        );
        return false;
      }
    } finally {
      keepAliveLink.close();
    }
  }
}

final avatarUploadProvider =
    NotifierProvider.autoDispose<AvatarUploadNotifier, AvatarUploadState>(
  AvatarUploadNotifier.new,
);

enum ProfileUpdateStatus { idle, loading, success, error }

class ProfileUpdateState {
  final ProfileUpdateStatus status;
  final String? errorMessage;

  const ProfileUpdateState({
    this.status = ProfileUpdateStatus.idle,
    this.errorMessage,
  });

  bool get isLoading => status == ProfileUpdateStatus.loading;
  bool get isSuccess => status == ProfileUpdateStatus.success;
  bool get isError => status == ProfileUpdateStatus.error;
}

class ProfileUpdateNotifier extends Notifier<ProfileUpdateState> {
  @override
  ProfileUpdateState build() {
    return const ProfileUpdateState();
  }

  Future<bool> update({required String name, String? serviceId}) async {
    final keepAliveLink = ref.keepAlive();
    try {
      state = const ProfileUpdateState(status: ProfileUpdateStatus.loading);
      final repo = ref.read(profileRepositoryProvider);
      final success = await repo.updateProfileDetails(name: name, serviceId: serviceId);
      if (success) {
        state = const ProfileUpdateState(status: ProfileUpdateStatus.success);
        ref.invalidate(profileProvider);
        return true;
      } else {
        state = const ProfileUpdateState(
          status: ProfileUpdateStatus.error,
          errorMessage: "Failed to update profile",
        );
        return false;
      }
    } finally {
      keepAliveLink.close();
    }
  }
}

final profileUpdateProvider =
    NotifierProvider.autoDispose<ProfileUpdateNotifier, ProfileUpdateState>(
  ProfileUpdateNotifier.new,
);
