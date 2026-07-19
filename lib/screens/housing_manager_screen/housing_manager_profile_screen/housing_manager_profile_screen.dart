import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/widgets/profile_button_widgets.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/provider/profile_provider.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/user_role_provider.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/navigation_provider.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image_circular.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

import '../../../widgets/image_userPick/image_user_pick.dart';

class HousingManagerProfileScreen extends ConsumerStatefulWidget {
  const HousingManagerProfileScreen({super.key});

  @override
  ConsumerState<HousingManagerProfileScreen> createState() => _HousingManagerProfileScreenState();
}

class _HousingManagerProfileScreenState extends ConsumerState<HousingManagerProfileScreen> {

  Future<void> housingLogout()async{
    try{
      await StorageServices.instance.logout();
      ref.read(navigationProvider.notifier).state = 0;
      ref.read(userRoleProvider.notifier).setRole("");

      AppRoutes.instance.go(AppRoutesKey.instance.loginScreen);
    }catch(e){
      errorLog("Error is", e);
    }
  }
  @override
  Widget build(BuildContext context) {
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
                      child: Consumer(
                        builder: (context, ref, child) {
                          final profileAsync = ref.watch(profileProvider);
                          return profileAsync.when(
                            data: (profileModel) {
                              final user = profileModel?.data.user;
                              final avatarUrl = user?.avatarUrl;
                              final name = user?.name ?? '';
                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      AppImageCircular(
                                        url: (avatarUrl != null && avatarUrl.isNotEmpty)
                                            ? avatarUrl
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
                                  Gap(height: 10),
                                  AppText(
                                    text: name,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.instance.textHeading,
                                  ),
                                ],
                              );
                            },
                            loading: () => Column(
                              children: [
                                SizedBox(
                                  height: AppSize.height(value: 67),
                                  width: AppSize.width(value: 66),
                                  child: const CircularProgressIndicator(color: Colors.white),
                                ),
                                Gap(height: 10),
                                AppText(
                                  text: "Loading...",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.instance.textHeading,
                                ),
                              ],
                            ),
                            error: (error, _) => Column(
                              children: [
                                SizedBox(
                                  height: AppSize.height(value: 67),
                                  width: AppSize.width(value: 66),
                                  child: const Icon(Icons.error, color: Colors.white),
                                ),
                                Gap(height: 10),
                                AppText(
                                  text: "Error loading profile",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.instance.textHeading,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 66,
                  right: 25,
                  child: IconButtonWidget(
                    onTap: () {
                      AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.housingProfileEditScreen,
                      );
                    },
                    color: AppColors.instance.gray52,
                    child: Image.asset(
                      AppAssertsIconsPath.instance.editIcon,
                      scale: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Quick action",
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Gap(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.instance.grayE2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ProfileButtonWidget(
                            title: "Notification",
                            subTitle: "Go for visit notification",
                            onTap: () {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey
                                    .instance
                                    .housingManagerNotificationScreen,
                              );
                            },
                          ),
                          ProfileButtonWidget(
                            title: "Contractor info",
                            subTitle: "Go for visit Contractor information",
                            onTap: () {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey.instance.housingContractorInfo,
                              );
                            },
                          ),
                          ProfileButtonWidget(
                            title: "Subscription",
                            subTitle: "Go for visit subscription plan",
                            onTap: () {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey.instance.housingSubscriptionScreen,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Account",
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Gap(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.instance.grayE2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ProfileButtonWidget(
                            title: "Privacy & policy",
                            subTitle: "Go for visit Privacy & policy",
                            onTap: () {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey.instance.privacyPolicyScreen,
                              );
                            },
                          ),
                          ProfileButtonWidget(
                            title: "Terms & conditions",
                            subTitle: "Go for visit Terms & conditions",
                            onTap: () {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey.instance.termsAndConditionsScreen,
                              );
                            },
                          ),
                          ProfileButtonWidget(
                            title: "About",
                            subTitle: "Go for visit About",
                            onTap: () {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey.instance.aboutUsScreen,
                              );
                            },
                          ),
                          ProfileButtonWidget(
                            title: "FAQ",
                            subTitle: "Go for visit FAQ",
                            onTap: () {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey.instance.faqScreen,
                              );
                            },
                          ),
                          ProfileButtonWidget(
                            title: "Password",
                            subTitle:
                                "If you want to change password click here",
                            onTap: () {
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.changePasswordScreen);
                            },
                          ),
                          ProfileButtonWidget(
                            title: "Delete account",
                            color: AppColors.instance.error,
                            subTitle:
                                "We will remove your all data from our databaset",
                            onTap: () {
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.contractorDeleteAccountScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                housingLogout();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.instance.grayE2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.instance.error),
                        Gap(width: 15),
                        AppText(
                          text: "Log Out",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.instance.error,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
