import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';

import '../../../constant/app_constant.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/gap.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../../widgets/buttons/icon_button_widget.dart';
import '../../../widgets/texts/app_text.dart';

class ContractDeleteAccountForm extends StatelessWidget {
  const ContractDeleteAccountForm({super.key});

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
              child: Column(
                children: [
                  Gap(height: 20,),
                  AppText(
                    text: "Enter the login information for your DBN \naccount to confirm deletion.",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                    textAlign: TextAlign.center,
                    fontFamily: AppConstant.instance.segoeUi,
                  ),
                  Gap(height: 15,),
                  AppInputWidgetTwo(
                    title: "Email",
                  ),
                  AppInputWidgetTwo(
                    title: "password",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: AppButton(height: 40,title: "Continue to delete account",),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
