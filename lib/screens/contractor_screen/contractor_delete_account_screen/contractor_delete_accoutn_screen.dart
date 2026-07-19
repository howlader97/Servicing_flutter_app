import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

import '../../../routes/app_routes.dart';

class ContractorDeleteAccountScreen extends StatelessWidget {
  const ContractorDeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    IconButtonWidget(
                      color: AppColors.instance.primary,
                      onTap: () {
                        AppRoutes.instance.pop();
                      },
                      child: Icon(Icons.arrow_back_outlined),
                    ),
                    Gap(width: 15),
                    AppText(
                      text: "Delete My Account",
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
                padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                child: Column(
                  children: [
                    Gap(height: 20,),
                    AppText(
                    text: "Deleting your Common Ground account will permanently remove all public and private information associated with your profile.",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                      fontFamily: AppConstant.instance.segoeUi,
                              ),
                    Gap(height: 25,),
                    AppButton(
                      onTap: (){
                        AppRoutes.instance.pushNamed(AppRoutesKey.instance.contractDeleteAccountForm);
                      },
                      height: 40,title: "Continue to delete account",)
                  ],
                ),
              ),
             )
          ],
        ),
      ),
    );
  }
}
