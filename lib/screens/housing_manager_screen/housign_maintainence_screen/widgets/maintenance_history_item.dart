import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class MaintenanceHistoryItem extends StatelessWidget {
  final String title;
  final String dateAndType;
  final String price;

  const MaintenanceHistoryItem({
    super.key,
    required this.title,
    required this.dateAndType,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.instance.textHeading,
              ),
              const SizedBox(height: 4),
              AppText(
                text: dateAndType,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.instance.gray50,
              ),
            ],
          ),
        ),
        AppText(
          text: price,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.instance.textHeading,
        ),
      ],
    );
  }
}