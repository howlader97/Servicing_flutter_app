import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({
    super.key, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Row(
        children: [
          IconButtonWidget(
            color: AppColors.instance.primary,
            onTap: () => AppRoutes.instance.pop(),
            child: Icon(Icons.arrow_back_outlined, color: AppColors.instance.white),
          ),
          const Gap(width: 15),
          AppText(
            text: title,
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: AppColors.instance.textHeading,
          ),
        ],
      ),
    );
  }
}