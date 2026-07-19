import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contract_job_evidence_screen/provider/contract_job_evidence_provider.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/widgets/image_userPick/image_user_pick.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/buttons/icon_button_widget.dart';

class ContractJobEvidenceScreen extends ConsumerStatefulWidget {
  final String jobId;
  const ContractJobEvidenceScreen({super.key, required this.jobId});

  @override
  ConsumerState<ContractJobEvidenceScreen> createState() =>
      _ContractJobEvidenceScreenState();
}

class _ContractJobEvidenceScreenState extends ConsumerState<ContractJobEvidenceScreen> {

  final TextEditingController descriptionController = TextEditingController();
  final List<String> selectedImages = [];

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    IconButtonWidget(
                      color: AppColors.instance.primary,
                      onTap: () {
                        AppRoutes.instance.pop();
                      },
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: AppColors.instance.white,
                      ),
                    ),
                    const Gap(width: 15),
                    AppText(
                      text: "Job Evidence",
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInputWidgetTwo(
                    title: "Description",
                    hintText: "Tell us what's broken...",
                    controller: descriptionController,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(height: 10),
                    AppText(
                      text: "Upload photos",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.instance.textHeading,
                    ),
                    const Gap(height: 15),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ...selectedImages.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final String path = entry.value;
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(path),
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: -4,
                                right: -4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImages.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        // Add Button Container
                        GestureDetector(
                          onTap: () {
                            appImageUserTake(
                              callBack: (path) {
                                if (path.isNotEmpty) {
                                  setState(() {
                                    selectedImages.add(path);
                                  });
                                }
                              },
                            );
                          },
                          child: CustomPaint(
                            painter: DashedRectPainter(
                              color: AppColors.instance.black300,
                              strokeWidth: 1.2,
                              dashLength: 6,
                              gap: 4,
                              borderRadius: 12,
                            ),
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: AppColors.instance.grayE2.withValues(
                                  alpha: 0.4,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.instance.black900,
                                  ),
                                  const Gap(height: 4),
                                  AppText(
                                    text: "Add",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.instance.black900,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 24.0,
                ),
                child: AppButton(
                  title: "Submit Request",
                  height: 44,
                  isLoading: ref.watch(contractJobEvidenceProvider).isLoading,
                  onTap: () {
                    if (descriptionController.text.trim().isEmpty) {
                      AppSnackBar.instance.error("Please enter a description");
                      return;
                    }
                    if (selectedImages.isEmpty) {
                      AppSnackBar.instance.error("Please upload at least one photo");
                      return;
                    }
                    ref.read(contractJobEvidenceProvider.notifier).submit(
                          jobId: widget.jobId,
                          description: descriptionController.text.trim(),
                          photos: selectedImages,
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedRectPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.dashLength = 5.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    double distance = 0.0;
    bool draw = true;

    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double len = draw ? dashLength : gap;
        if (draw) {
          dashPath.addPath(
            pathMetric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
