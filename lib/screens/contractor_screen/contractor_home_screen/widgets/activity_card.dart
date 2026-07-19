import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

import '../../../../constant/app_asserts_icons_path.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const ActivityCard({
    super.key, required this.title, required this.subtitle, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(

      mainAxisAlignment:.spaceBetween,
      children: [
      IconButtonWidget(color: AppColors.instance.bottomColor, child: Image.asset(AppAssertsIconsPath.instance.jobIcon,scale: 3,),),
      Gap(width: 10,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: title,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.instance.textHeading,
            ),
            AppText(
              text: subtitle,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.instance.gray52,
              fontFamily: AppConstant.instance.libreFranklin,
            ),
          ],
        ),
      ),
      child

    ],);
  }
}