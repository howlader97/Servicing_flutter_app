import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class ContractJobSuccess extends StatelessWidget {
  const ContractJobSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButtonWidget(
                      color: AppColors.instance.primary,
                      onTap: () {
                        AppRoutes.instance.pop();
                      },
                      child: Icon(Icons.arrow_back_outlined, color: AppColors.instance.white),
                    ),
                    const Gap(width: 15),
                    AppText(
                      text: "Job abidance submit",
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(height: 30),
                    // Hourglass stack icon
                    Image.asset(AppAssertsImagePath.instance.progressImage,scale: 4,),
                    const Gap(height: 30),
                    // Title
                    AppText(
                      text: "Job verification in Progress",
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(height: 10),
                    // Description
                    AppText(
                      text: "The housing manager will review your work then verify it, and provide feedback shortly.",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                      textAlign: TextAlign.center,
                      fontFamily: AppConstant.instance.libreFranklin,
                    ),
                    const Gap(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.instance.grayE2.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AppText(
                        text: "Thank you for your \npatience.",
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.primary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(height: 40),
                    AppButton(
                      title: "Go Back",
                      height: 44,
                      onTap: () {
                        AppRoutes.instance.go(AppRoutesKey.instance.appNavigationScreen);
                      },
                    ),
                    const Gap(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
