import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_subscription_screen/provider/select_subscription_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_subscription_screen/widgets/subscription_card.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class HousingSubscriptionScreen extends StatelessWidget {
  const HousingSubscriptionScreen({super.key});

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
                      text: "Subscription",
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ClipRRect(
                child: Align(
                  child:AppImage(
                    path: AppAssertsImagePath.instance.crownImage,
                    height: AppSize.height(value: 150),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 35),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayE2.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border(
                      top: BorderSide(color: Color(0xFFD42123), width: .5),
                      left: BorderSide(color: Color(0xFFD42123), width: .5),
                      right: BorderSide(color: Color(0xFFD42123), width: .5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "What benefit",
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: AppColors.instance.textHeading,
                        ),
                        Gap(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: ". What benefit",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.instance.textHeading,
                                fontFamily: AppConstant.instance.segoeUi,
                              ),
                              AppText(
                                text: ". Marketplace Advertising",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.instance.textHeading,
                                  fontFamily: AppConstant.instance.segoeUi,
                              ),
                              AppText(
                                text: ". Store management",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.instance.textHeading,
                                  fontFamily: AppConstant.instance.segoeUi,
                              ),
                              AppText(
                                text: ". Marketing Operating",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.instance.textHeading,
                                  fontFamily: AppConstant.instance.segoeUi,
                              ),
                              Gap(height: 10,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 12,
                ),
                child: AppText(
                  text: "Join Membership",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: AppColors.instance.textHeading,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final select = ref.watch(selectSubscriptionProvider);
                          return SubscriptionCard(
                            onTap: () {
                              ref
                                      .read(selectSubscriptionProvider.notifier)
                                      .state =
                                  0;
                            },
                            title: 'Monthly Membership',
                            subtitle: 'Billed Monthly',
                            price: '\$10',
                            isSelected: select == 0,
                            color: select == 0
                                ? AppColors.instance.grayE2
                                : AppColors.instance.transparent,
                          );
                        },
                      ),
                    ),
                    Gap(width: 10),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final select = ref.watch(selectSubscriptionProvider);
                          return SubscriptionCard(
                            onTap: () {
                              ref
                                      .read(selectSubscriptionProvider.notifier)
                                      .state =
                                  1;
                            },
                            title: 'Annual Membership',
                            subtitle: 'Billed Yearly',
                            price: '\$100',
                            isSelected:  select ==1,
                            color: select == 1
                                ? AppColors.instance.grayE2
                                : AppColors.instance.transparent,
                          );
                        },
                      ),
                    ),
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
