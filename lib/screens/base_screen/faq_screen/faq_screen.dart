import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/base_screen/faq_screen/providers/f_a_q_screen_provider.dart';
import 'package:flutter_riverpod_template/screens/base_screen/faq_screen/widgets/faq_card.dart';
import 'package:flutter_riverpod_template/screens/base_screen/faq_screen/widgets/faq_card_loader.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/buttons/icon_button_widget.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  IconButtonWidget(
                    color: AppColors.instance.primary,
                    onTap: () {
                      AppRoutes.instance.pop();
                    },
                    child: const Icon(Icons.arrow_back_outlined),
                  ),
                  const Gap(width: 15),
                  AppText(
                    text: "FAQ",
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                ],
              ),
            ),
            const Gap(height: 10),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  var provider = ref.watch(fAQScreenProvider);
                  var expandedId = ref.watch(expandedFaqIdProvider);

                  return provider.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return const Center(child: AppText(text: "No FAQs Found"));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var item = data[index];
                          return FaqCard(
                            item: item,
                            isSelected: expandedId == item.id,
                            onTap: () {
                              ref.read(expandedFaqIdProvider.notifier).state =
                                  expandedId == item.id ? null : item.id;
                            },
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return const Center(child: AppText(text: "Something Went Wrong"));
                    },
                    loading: () => Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return const FaqCardLoader();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
