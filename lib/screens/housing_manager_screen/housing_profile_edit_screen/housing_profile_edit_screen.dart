import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/provider/profile_provider.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image_circular.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

import '../../../widgets/image_userPick/image_user_pick.dart';

class HousingProfileEditScreen extends ConsumerStatefulWidget {
  const HousingProfileEditScreen({super.key});

  @override
  ConsumerState<HousingProfileEditScreen> createState() =>
      _HousingProfileEditScreenState();
}

class _HousingProfileEditScreenState extends ConsumerState<HousingProfileEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    profile.whenData((data) {
      if (data != null) {
        if (_nameController.text.isEmpty) {
          _nameController.text = data.data.user.name;
        }
        if (_emailController.text.isEmpty) {
          _emailController.text = data.data.user.email;
        }
      }
    });

    final updateState = ref.watch(profileUpdateProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.instance.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 18,
                        top: AppSize.height(value: 65),
                        right: 18,
                        bottom: 22,
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              AppImageCircular(
                                url: (profile.value?.data.user.avatarUrl != null &&
                                        profile.value!.data.user.avatarUrl!.isNotEmpty)
                                    ? profile.value!.data.user.avatarUrl
                                    : "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
                                height: AppSize.height(value: 67),
                                width: AppSize.width(value: 66),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    appImageUserTake(callBack: (v) async {
                                      if (v.isNotEmpty) {
                                        final success = await ref
                                            .read(avatarUploadProvider.notifier)
                                            .upload(v);
                                        if (success) {
                                          AppSnackBar.instance
                                              .success("Profile picture updated successfully");
                                        } else {
                                          AppSnackBar.instance
                                              .error("Failed to update profile picture");
                                        }
                                      }
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.instance.white,
                                    radius: 15,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.instance.textHeading,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 66,
                  left: 25,
                  child: IconButtonWidget(
                    onTap: () {
                      AppRoutes.instance.pop();
                    },
                    color: AppColors.instance.gray52,
                    child: const Icon(Icons.arrow_back_outlined),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                AppInputWidgetTwo(
                  title: 'Name',
                  controller: _nameController,
                  hintText: "Enter your name",
                ),
                AppInputWidgetTwo(
                  title: 'Email',
                  controller: _emailController,
                  hintText: "Email",
                  readOnly: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 16,
                  ),
                  child: AppButton(
                    isLoading: updateState.isLoading,
                    onTap: () async {
                      if (_nameController.text.trim().isEmpty) {
                        AppSnackBar.instance.error("Name cannot be empty");
                        return;
                      }
                      final success = await ref
                          .read(profileUpdateProvider.notifier)
                          .update(name: _nameController.text.trim());
                      if (success) {
                        AppSnackBar.instance
                            .success("Profile updated successfully");
                        AppRoutes.instance.pop();
                      } else {
                        AppSnackBar.instance
                            .error("Failed to update profile");
                      }
                    },
                    backgroundColor: AppColors.instance.primary,
                    height: AppSize.height(value: 40),
                    title: "Save Update",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
