import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/image_slider.dart';

import '../housing_create_job_screen/widgets/custom_app_bar.dart';
import 'provider/issue_details_provider.dart';
import '../housing_job_details_screen/widgets/details_row.dart';

class HousingIssueDetailsScreen extends ConsumerWidget {
  final String issueId;
  const HousingIssueDetailsScreen({super.key, required this.issueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issueAsync = ref.watch(issueDetailsProvider(issueId));

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter( child: CustomAppBar(title: "Job details")),
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
                  child: issueAsync.when(
                    data: (issue) {
                      if (issue == null) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text("Issue details not found"),
                          ),
                        );
                      }

                      final images = issue.images.isNotEmpty
                          ? issue.images
                          : [
                        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600',
                      ];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ImageSlider(
                            images: images,
                            status: issue.isResolved ? "complete" : "pending",
                          ),
                          const Gap(height: 20),

                          DetailRow(
                            label: "Issue name",
                            value: issue.title,
                          ),
                          DetailRow(
                            label: "Task details",
                            value: issue.description,
                          ),
                          DetailRow(
                            label: "Property ID",
                            value: issue.property.propertyCode,
                          ),
                          DetailRow(
                            label: "Property location",
                            value: issue.property.location,
                          ),
                          DetailRow(
                            label: "Priority Levels",
                            value: "High",
                            valueColor: AppColors.instance.error,
                          ),
                          DetailRow(
                            label: "Community name",
                            value: issue.category.name,
                          ),
                          const DetailRow(
                            label: "Assign to",
                            value: "Not yet",
                          ),
                          const DetailRow(
                            label: "Assign Time",
                            value: "Not yet",
                          ),
                          const DetailRow(
                            label: "End Time",
                            value: "Not yet",
                          ),
                          DetailRow(
                            label: "Status",
                            value: issue.isResolved ? "complete" : "pending",
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text("Error loading details: $error"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(height: 20)),
          ],
        ),
      ),
    );
  }
}