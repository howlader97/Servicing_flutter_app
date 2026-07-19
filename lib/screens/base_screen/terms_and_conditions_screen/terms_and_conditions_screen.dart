import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/base_screen/terms_and_conditions_screen/provider/terms_and_conditions_screen_provider.dart';
import 'package:flutter_riverpod_template/screens/base_screen/widgets/base_data_widget.dart';
import 'package:flutter_riverpod_template/screens/base_screen/widgets/base_no_found_data_widget.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/buttons/icon_button_widget.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.white400,
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
                    text: "Terms & conditions",
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  var provider = ref.watch(termsAndConditionsScreenProvider);
                  return provider.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return const BaseNoFoundDataWidget();
                      }
                      return BaseDataWidget(data: data);
                    },
                    error: (error, stackTrace) => const BaseNoFoundDataWidget(),
                    loading: () => const Skeletonizer(enabled: true, child: BaseNoFoundDataWidget()),
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
