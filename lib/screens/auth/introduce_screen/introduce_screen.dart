import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/auth/introduce_screen/provider/selectRoleProvider.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/user_role_provider.dart';


class IntroduceScreen extends ConsumerWidget {
  const IntroduceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.instance.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Gap(height: 5),
                  Image.asset(
                    AppAssertsIconsPath.instance.splashIcon,
                    scale: 5,
                  ),
                  Gap(height: 12),
                  AppText(
                    text: "Introduce Yourself",
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Gap(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21.0),
                    child: AppText(
                      text:
                          "If this is your first time here, please select any one role to sign up.",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      color: AppColors.instance.textColor,
                    ),
                  ),
                  Gap(height: 25),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context,ref,child) {
                          final selectRoll = ref.watch(selectRoleProvider);
                          return GestureDetector(
                            onTap: () {
                              ref.read(selectRoleProvider.notifier).state = 0;
                              ref.read(userRoleProvider.notifier).setRole("HOUSING_MANAGER");
                            },
                            child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.instance.grayE2,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SizedBox(
                                    height: 216,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Icon(Icons.check_circle_rounded,size: 28, color: selectRoll == 0 ?Colors.green :AppColors.instance.gray400,),
                                        AppImage(
                                          path: AppAssertsImagePath
                                              .instance
                                              .housingManager,
                                          height: AppSize.height(value: 130),
                                          width: AppSize.width(value: 130),
                                        ),
                                         Spacer(),
                                        Center(child: AppText(text: "HOUSING_MANAGER",)),
                                      ],),
                                    )
                                  ),
                                ),
                          );
                        }
                      ),


                    ),
                    Gap(width: 10),
                    Expanded(
                      child: Consumer(
                        builder: (context,ref,child) {
                          final selectRoll =ref.watch(selectRoleProvider);
                          return GestureDetector(
                            onTap: () {
                              ref.read(selectRoleProvider.notifier).state = 1;
                              ref.read(userRoleProvider.notifier).setRole("CONTRACTOR");
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.instance.grayE2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SizedBox(
                                  height: 216,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.check_circle_rounded,size: 28, color: selectRoll == 1 ? Colors.green : AppColors.instance.gray400,),
                                        AppImage(
                                          path: AppAssertsImagePath
                                              .instance
                                              .contractorImage,
                                          height: AppSize.height(value: 130),
                                          width: AppSize.width(value: 130),
                                        ),
                                       Spacer(),
                                        Center(child: AppText(text: "CONTRACTOR",)),
                                      ],),
                                  )
                              ),
                            ),
                          );
                        }
                      ),


                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 30,
                ),
                child: AppButton(
                  onTap: () {
                    final roleIndex = ref.read(selectRoleProvider);
                    if (roleIndex == 0) {
                      ref.read(userRoleProvider.notifier).setRole("HOUSING_MANAGER");
                    } else if (roleIndex == 1) {
                      ref.read(userRoleProvider.notifier).setRole("CONTRACTOR");
                    }
                    AppRoutes.instance.push(AppRoutesKey.instance.signUpScreen);
                  },
                  height: AppSize.height(value: 46),
                  backgroundColor: AppColors.instance.primary,
                  title: "Next",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
