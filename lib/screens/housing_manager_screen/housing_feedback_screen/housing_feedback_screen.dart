import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_create_job_screen/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_job_details_screen/widgets/details_row.dart';
import 'package:flutter_riverpod_template/widgets/app_image/image_slider.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/models/all_jobs_model.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_feedback_screen/provider/housing_feedback_provider.dart';

import '../../../utils/gap.dart';
import '../../../widgets/buttons/app_button.dart';

class HousingFeedbackScreen extends StatelessWidget {
  final Job job;
  const HousingFeedbackScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: CustomAppBar(title: "Job details")),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 10.0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayE2,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ImageSlider(
                        images: job.images.isNotEmpty
                            ? job.images.map((e) => e.imageUrl).toList()
                            : [],
                        status: job.status.toUpperCase() == "PENDING_APPROVAL" ? "complete" : job.status,
                        isStatus: true,
                      ),
                      const Gap(height: 20),
                      DetailRow(
                        label: "Issue name",
                        value: job.title,
                      ),
                      DetailRow(
                        label: "Task details",
                        value: job.description,
                      ),
                      DetailRow(
                        label: "Property ID",
                        value: job.property.propertyCode,
                      ),
                      DetailRow(
                        label: "Property location",
                        value: job.property.location,
                      ),
                      DetailRow(
                        label: "Priority Levels",
                        value: job.priority,
                        valueColor: AppColors.instance.error,
                      ),
                      const DetailRow(label: "Community name", value: ""),
                      DetailRow(
                        label: "Assign to",
                        value: job.assignedTo.companyName,
                      ),
                      DetailRow(
                        label: "Assign Time",
                        value: "${job.createdAt}",
                      ),
                      DetailRow(
                        label: "End Time",
                        value: "${job.completedAt}",
                      ),
                      DetailRow(
                        label: "Status",
                        value: job.status.toUpperCase() == "PENDING_APPROVAL" ? "complete" : job.status,
                      ),
                      const Gap(height: 10,),
                      AppButton(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return _FeedbackBottomSheet(jobId: job.id);
                            },
                          );
                        },
                        title: "Feedback",
                        height: 44,
                        titleColor: AppColors.instance.gray52,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackBottomSheet extends ConsumerStatefulWidget {
  final String jobId;
  const _FeedbackBottomSheet({required this.jobId});

  @override
  ConsumerState<_FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends ConsumerState<_FeedbackBottomSheet> {
  int rating = 0;
  final TextEditingController reviewController = TextEditingController();
  int charCount = 0;

  @override
  void initState() {
    super.initState();
    reviewController.addListener(() {
      setState(() {
        charCount = reviewController.text.length;
      });
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackState = ref.watch(housingFeedbackProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.instance.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const Gap(height: 15),
            const AppText(
              text: "Tap the stars to rate this Contractor",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            const Gap(height: 10),
            Row(
              children: List.generate(5, (index) {
                final isSelected = index < rating;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            const Gap(height: 20),
            const AppText(
              text: "Write something",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            const Gap(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                controller: reviewController,
                maxLines: 4,
                maxLength: 500,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: "Input your review",
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  counterText: "",
                ),
              ),
            ),
            const Gap(height: 5),
            Align(
              alignment: Alignment.topRight,
              child: AppText(
                text: "$charCount/500",
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const Gap(height: 20),
            AppButton(
              isLoading: feedbackState.isLoading,
              onTap: () async {
                if (rating == 0) {
                  AppSnackBar.instance.error("Please select a rating");
                  return;
                }
                final comment = reviewController.text.trim();
                if (comment.isEmpty) {
                  AppSnackBar.instance.error("Please enter a review comment");
                  return;
                }
                final success = await ref
                    .read(housingFeedbackProvider.notifier)
                    .submitFeedback(
                      jobId: widget.jobId,
                      rating: rating,
                      comment: comment,
                    );
                if (success && context.mounted) {
                  Navigator.pop(context);
                  AppSnackBar.instance.success("Feedback submitted successfully");
                  AppRoutes.instance.pop();
                }
              },
              title: "Submit",
              backgroundColor: AppColors.instance.gray52,
              borderColor: AppColors.instance.transparent,
              titleColor: Colors.white,
              height: 44,
            ),
            const Gap(height: 10),
          ],
        ),
      ),
    );
  }
}