import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class ProfileButtonWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color? color;
  final VoidCallback onTap;
  const ProfileButtonWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.instance.bottomColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 14),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: color ?? AppColors.instance.textHeading,
                    ),
                    Gap(height: 8,),
                    AppText(
                      text: subTitle,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.gray52,
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward,color: AppColors.instance.textHeading,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}