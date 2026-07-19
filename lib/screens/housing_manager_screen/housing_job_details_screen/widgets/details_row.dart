import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';

import '../../../../constant/app_colors.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppColors.instance.textHeading,
                fontFamily: AppConstant.instance.oswald
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: valueColor ?? AppColors.instance.gray52,
                  fontFamily: AppConstant.instance.libreFranklin
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}