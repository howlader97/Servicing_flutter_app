import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class CustomContainer extends StatelessWidget {
  final Color color;
  final String imageUrl;
  final String? issueName;
  final String propertyId;
  final String propertyLocation;
  final String? communityName;
  final String? jobCreateTime;
  final String? jobStatus;
  final bool? isStatus;
  final String status;
  final bool? isButton;
  final bool? isCompleteButton;
  final bool isDetails;
  final String? detailText;
  final VoidCallback? viewButton;
  final VoidCallback? acceptButton;
  final VoidCallback? contractButton;
  final String? buttonTitle;
  final bool? community;
  final bool? isContractor;

  const CustomContainer({
    super.key,
    required this.color,
    required this.imageUrl,
    this.issueName,
    required this.propertyId,
    required this.propertyLocation,
    required this.status,
    this.isStatus = false,
    this.isButton = false,
    this.isDetails = false,
    this.detailText,
    this.isCompleteButton = false,
    this.viewButton,
    this.communityName,
    this.community = false,
    this.jobCreateTime,
    this.jobStatus,
    this.acceptButton,
    this.buttonTitle,
    this.isContractor =false,
    this.contractButton,
  });

  Color getsStatusColor() {
    switch (status.toLowerCase()) {
      case 'inprogress':
        return AppColors.instance.primary;
      case 'complete':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      case 'decline':
        return Colors.amber;
      default:
        return AppColors.instance.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AppImage(
                      url: imageUrl,
                      height: 166,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isStatus == true) ...[
                    Positioned(
                      top: 0,
                      right: 0,
                      child: AppButton(
                        title: status,
                        fontSize: 12,
                        backgroundColor: getsStatusColor(),
                        borderColor: AppColors.instance.transparent,
                      ),
                    ),
                  ],
                ],
              ),

              Gap(height: 10),
              if (!isDetails) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Issue name :",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                    Expanded(
                      child: AppText(
                        text: issueName ?? '',
                        fontSize: 16,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.gray52,
                        fontFamily: AppConstant.instance.libreFranklin,
                      ),
                    ),
                  ],
                ),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Property ID :",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Expanded(
                    child: AppText(
                      text: propertyId,
                      fontSize: 16,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.gray52,
                      fontFamily: AppConstant.instance.libreFranklin,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Property location :",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Expanded(
                    child: AppText(
                      text: propertyLocation,
                      fontSize: 16,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.gray52,
                      fontFamily: AppConstant.instance.libreFranklin,
                    ),
                  ),
                ],
              ),
              if (community == true) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Community name :",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                    Expanded(
                      child: AppText(
                        text: communityName ?? '',
                        fontSize: 16,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.gray52,
                        fontFamily: AppConstant.instance.libreFranklin,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Job create time :",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                    Expanded(
                      child: AppText(
                        text: jobCreateTime ?? '',
                        fontSize: 16,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.gray52,
                        fontFamily: AppConstant.instance.libreFranklin,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Job status :",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                    Expanded(
                      child: AppText(
                        text: jobStatus ?? '',
                        fontSize: 16,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.gray52,
                        fontFamily: AppConstant.instance.libreFranklin,
                      ),
                    ),
                  ],
                ),
              ],
              if (isDetails) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Details :",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                    Expanded(
                      child: AppText(
                        text: detailText ?? '',
                        fontSize: 16,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.gray52,
                        fontFamily: AppConstant.instance.libreFranklin,
                      ),
                    ),
                  ],
                ),
              ],
              if (isCompleteButton == true) ...[
                Gap(height: 15),
                AppButton(
                  onTap: acceptButton,
                  title: buttonTitle,
                  height: 44,
                  backgroundColor: AppColors.instance.primary,
                  borderColor: AppColors.instance.primary,
                ),
              ],
              if (isButton == true) ...[
                Gap(height: 10),
                AppButton(
                  onTap: viewButton,
                  title: status == 'COMPLETED' || status == "PENDING_APPROVAL" || status == "IN_PROGRESS"
                      ? 'View Details'
                      : "Reassign",
                  height: 44,
                  backgroundColor: status == 'COMPLETED' || status == "PENDING_APPROVAL" ||status == "IN_PROGRESS"
                      ? AppColors.instance.gray52
                      : AppColors.instance.primary
                       ,
                  borderColor: AppColors.instance.transparent,
                ),
              ],
              if (isContractor == true) ...[
                Gap(height: 10),
                AppButton(
                  onTap: contractButton,
                  title:  'View Details',
                  height: 44,
                  backgroundColor: AppColors.instance.gray52,
                  borderColor: AppColors.instance.transparent,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
