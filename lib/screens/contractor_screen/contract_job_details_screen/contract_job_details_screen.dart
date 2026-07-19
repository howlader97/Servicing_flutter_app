import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_jobs_screen/provider/contractor_jobs_provider.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contract_job_details_screen/provider/contractor_job_details_provider.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contract_job_details_screen/provider/contractor_job_action_provider.dart';
import '../../../constant/app_colors.dart';
import '../../../utils/gap.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../widgets/app_image/image_slider.dart';
import '../../housing_manager_screen/housing_create_job_screen/widgets/custom_app_bar.dart';
import '../../housing_manager_screen/housing_job_details_screen/widgets/details_row.dart';

class ContractJobDetailsScreen extends ConsumerWidget {
  final String? jobId;

  const ContractJobDetailsScreen({super.key, this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (jobId == null || jobId!.isEmpty) {
      return const Center(child: Text("Job details not found"));
    }

    final jobAsync = ref.watch(contractorJobDetailsProvider(jobId!));
    final actionState = ref.watch(contractorJobActionProvider);
    final actionNotifier = ref.read(contractorJobActionProvider.notifier);

    return jobAsync.when(
      data: (job) {
        if (job == null) {
          return const Scaffold(
            body: Center(child: Text("Job details not found")),
          );
        }

        final List<String> images = job.images.isNotEmpty
            ? job.images.map((img) => img.imageUrl).toList()
            : [
                'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600',
              ];

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
                          ImageSlider(images: images, status: job.status),
                          const Gap(height: 20),
                          DetailRow(
                            label: "Issue name",
                            value: job.title,
                          ),
                          DetailRow(
                            label: "Task details",
                            value: job.description.isNotEmpty
                                ? job.description
                                : "No description provided.",
                          ),
                          DetailRow(
                            label: "Property ID",
                            value: "#${job.property.propertyCode}",
                          ),
                          DetailRow(
                            label: "Property location",
                            value: job.property.location,
                          ),
                          DetailRow(
                            label: "Priority Levels",
                            value: job.priority.isNotEmpty
                                ? job.priority
                                : "Urgent",
                            valueColor: job.priority.toLowerCase() == 'urgent' ||
                                    job.priority.toLowerCase() == 'high'
                                ? AppColors.instance.error
                                : AppColors.instance.textHeading,
                          ),
                          DetailRow(
                            label: "Community name",
                            value: "",
                          ),
                          DetailRow(
                            label: "Assign Time",
                            value:
                                "${job.createdAt.hour.toString().padLeft(2, '0')}:${job.createdAt.minute.toString().padLeft(2, '0')} (${job.createdAt.day.toString().padLeft(2, '0')}/${job.createdAt.month.toString().padLeft(2, '0')}/${job.createdAt.year})",
                          ),
                          const Gap(height: 20),
                          if (job.status == "PENDING_APPROVAL" ||
                              job.status == "COMPLETED" ||
                              job.status == "CANCELLED") ...[
                            // No action buttons for these statuses
                          ] else if (job.status == "IN_PROGRESS") ...[
                            AppButton(
                              onTap: () {
                                AppRoutes.instance.push(
                                  AppRoutesKey.instance.contractJobEvidenceScreen,
                                  extra: jobId,
                                );
                              },
                              title: "Complete",
                              height: 44,
                            ),
                          ] else ...[

                            AppButton(
                              isLoading: actionState.isAcceptLoading,
                              onTap: actionState.isIdle
                                  ? () async {
                                      final success =
                                          await actionNotifier.acceptJob(jobId!);
                                      if (success) {
                                        AppSnackBar.instance
                                            .success("Job accepted successfully");
                                        ref.invalidate(
                                            contractorJobDetailsProvider(jobId!));
                                        ref
                                            .read(contractorJobsProvider.notifier)
                                            .refresh();
                                        AppRoutes.instance.pop();
                                      } else {
                                        AppSnackBar.instance
                                            .error("Failed to accept job");
                                      }
                                    }
                                  : null,
                              title: "Accept",
                              height: 44,
                            ),
                            const Gap(height: 20),
                            AppButton(
                              isLoading: actionState.isDeclineLoading,
                              backgroundColor: AppColors.instance.gray52,
                              borderColor: AppColors.instance.gray52,
                              onTap: actionState.isIdle
                                  ? () async {
                                      final success =
                                          await actionNotifier.declineJob(jobId!);
                                      if (success) {
                                        AppSnackBar.instance.success(
                                            "Job declined successfully");
                                        ref.invalidate(
                                            contractorJobDetailsProvider(jobId!));
                                        ref
                                            .read(contractorJobsProvider.notifier)
                                            .refresh();
                                        AppRoutes.instance.pop();
                                      } else {
                                        AppSnackBar.instance
                                            .error("Failed to decline job");
                                      }
                                    }
                                  : null,
                              title: "Decline",
                              height: 44,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Gap(height: 20)),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.instance.bottomColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.instance.primary,
          ),
        ),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: AppColors.instance.bottomColor,
        body: Center(
          child: Text(
            "Error: $err",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}