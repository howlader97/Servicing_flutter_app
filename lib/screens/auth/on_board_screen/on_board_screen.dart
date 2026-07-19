import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import '../../../widgets/texts/app_text.dart';

class OnBoardScreen extends ConsumerWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: AppColors.instance.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(8),child: AppImage(path: AppAssertsImagePath.instance.onBoard1,width: double.infinity,height: AppSize.height(value: 172),),),

                          Gap(height: 15,),
                          Row(children: [
                            Expanded(child:  ClipRRect(borderRadius: BorderRadius.circular(8),child: AppImage(path: AppAssertsImagePath.instance.onBoard2,height: AppSize.height(value: 172),),),),
                            Gap(width: 15,),
                            Expanded(child:  ClipRRect(borderRadius: BorderRadius.circular(8),child: AppImage(path: AppAssertsImagePath.instance.onBoard3,height: AppSize.height(value: 172),),),),
                          ],)

                        ],
                      ),
                    ),
                   // const SizedBox(height: 30),
                    // Text (Fixed)
                   AppText(
                      text: "Welcome to Common\n Ground",
                      textAlign: TextAlign.center,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.textBlack900,

                    ),
                  Gap(height: 25),
                    AppText(
                     text:  "Empowering communities with digital\n oversight.",
                      textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.instance.textBlack400,
                    ),
                    const SizedBox(height: 30),
                    AppButton(
                      onTap:() => AppRoutes.instance.go(AppRoutesKey.instance.loginScreen),
                      height: AppSize.height(value: 47),
                      backgroundColor: AppColors.instance.primary,
                      title: "Next",),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
