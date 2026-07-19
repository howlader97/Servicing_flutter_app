import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class OverviewBox extends StatelessWidget {
  final Widget child;
  final String subtext;
  final String text;
  const OverviewBox({
    super.key, required this.child, required this.subtext, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: AppColors.instance.grayE2),child: SizedBox(height: 140,child: Column(
      mainAxisAlignment: .spaceEvenly,
      children: [
        IconButtonWidget(color: AppColors.instance.primary, child: child),
        AppText(text: subtext,fontWeight: FontWeight.w400,fontSize: 16,color: AppColors.instance.gray52,),
        AppText(text: text,fontWeight: FontWeight.w400,fontSize: 24,color: AppColors.instance.textHeading,),
      ],
    ),),);
  }
}