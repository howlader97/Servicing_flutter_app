import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_create_job_screen/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_job_details_screen/widgets/details_row.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/image_slider.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_contractor_info/provider/housing_contractor_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_job_details_screen/provider/housing_job_details_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_job_screen/provider/job_provider.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/navigation_provider.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/services/repository/housing_job_repository.dart';
import '../../../models/all_jobs_model.dart';

class HousingJobDetailsScreen extends ConsumerStatefulWidget {
  final Job? job;
  final String? jobId;

  const HousingJobDetailsScreen({super.key, this.job, this.jobId});

  @override
  ConsumerState<HousingJobDetailsScreen> createState() =>
      _HousingJobDetailsScreenState();
}

class _HousingJobDetailsScreenState
    extends ConsumerState<HousingJobDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  Job? _fetchedJob;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.job == null && widget.jobId != null) {
      _fetchJobDetails();
    }
  }

  Future<void> _fetchJobDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final fetched = await HousingJobRepository.instance.getJobDetails(widget.jobId!);
      if (mounted) {
        setState(() {
          _fetchedJob = fetched;
          _isLoading = false;
          if (fetched == null) {
            _error = "Job details not found.";
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(housingContractorProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(housingJobDetailsProvider);
    final job = widget.job ?? _fetchedJob;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.instance.bottomColor,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(title: "Job details"),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.instance.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (job == null) {
      return Scaffold(
        backgroundColor: AppColors.instance.bottomColor,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(title: "Job details"),
              Expanded(
                child: Center(
                  child: AppText(
                    text: _error ?? "Job details not found.",
                    color: AppColors.instance.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }


    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
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
                        status: job.status,
                      ),
                      const Gap(height: 20),
                      DetailRow(label: "Issue name", value: job.title),
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
                      DetailRow(label: "Community name",
                          value:job.assignedTo.companyName),
                      DetailRow(
                        label: "Assign to",
                        value: "",
                      ),
                      DetailRow(
                        label: "Assign Time",
                        value: "${job.createdAt}",
                      ),
                      DetailRow(
                        label: "End Time",
                        value: "${job.completedAt}",
                      ),
                      DetailRow(label: "Status", value: job.status),
                      if (job.status == "PENDING_APPROVAL") ...[
                        Gap(height: 20),
                        AppButton(
                          isLoading: detailState.isApproving,
                          onTap: () async {
                            final success = await ref
                                .read(housingJobDetailsProvider.notifier)
                                .approveJob(job.id);
                            if (success) {
                              ref.read(jobProvider.notifier).refresh();
                              AppSnackBar.instance.success(
                                "Job approved successfully",
                              );
                              AppRoutes.instance.pushReplacementNamed(
                                AppRoutesKey.instance.housingFeedbackScreen,
                                extra: job,
                              );
                            }
                          },
                          title: "Approve work to complete",
                          height: 44,
                          titleColor: AppColors.instance.gray52,
                        ),
                        Gap(height: 10),
                        AppButton(
                          isLoading: detailState.isRejecting,
                          onTap: () async {
                            final success = await ref
                                .read(housingJobDetailsProvider.notifier)
                                .rejectJob(job.id);
                            if (success) {
                              ref.read(jobProvider.notifier).refresh();
                              AppSnackBar.instance.success(
                                "Job declined successfully",
                              );
                              ref.read(navigationProvider.notifier).state = 1;
                              AppRoutes.instance.pop();
                            }
                          },
                          title: "Decline",
                          height: 44,
                          backgroundColor: AppColors.instance.gray52,
                          borderColor: AppColors.instance.transparent,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(height: 20)),
            if (job.status.toUpperCase() != 'COMPLETED' &&
                job.status.toUpperCase() != 'PENDING_APPROVAL' &&
                job.status.toUpperCase() != 'IN_PROGRESS')
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 10.0,
                  ),
                  child: Builder(
                    builder: (context) {
                      final state = ref.watch(housingContractorProvider);
                      final contractors = state.contractors;

                      if (contractors.isEmpty && state.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (contractors.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.instance.grayE2,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            text: state.error ?? "No contractors found",
                            color: AppColors.instance.textColor,
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            contractors.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == contractors.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final contractor = contractors[index];

                          // Handle fields null-safely with professional defaults
                          final String displayName =
                              (contractor.companyName != null &&
                                  contractor.companyName!.trim().isNotEmpty)
                              ? contractor.companyName!
                              : (contractor.user.name.trim().isNotEmpty
                                    ? contractor.user.name
                                    : "Unnamed Contractor");

                          final String category =
                              (contractor.specialty != null &&
                                  contractor.specialty!.trim().isNotEmpty)
                              ? contractor.specialty!
                              : "General Contractor";

                          final String phone =
                              contractor.user.phone.trim().isEmpty
                              ? "No Phone Number"
                              : contractor.user.phone;

                          final String email =
                              contractor.user.email.trim().isEmpty
                              ? "No Email Address"
                              : contractor.user.email;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppColors.instance.grayE2,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: displayName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                const Gap(height: 8),
                                DetailRow(label: "Category", value: category),
                                DetailRow(label: "Phone", value: phone),
                                DetailRow(label: "Email", value: email),
                                const Gap(height: 12),
                                AppButton(
                                  isLoading:
                                      detailState.assigningContractorId ==
                                      contractor.id,
                                  title: "Assign",
                                  height: 46,
                                  onTap: () async {
                                    final success = await ref
                                        .read(
                                          housingJobDetailsProvider.notifier,
                                        )
                                        .assignJob(
                                          jobId: job.id,
                                          contractorId: contractor.id,
                                        );
                                    if (success) {
                                      AppSnackBar.instance.success(
                                        "Contractor assigned successfully",
                                      );
                                      ref.read(jobProvider.notifier).refresh();
                                      AppRoutes.instance.pop();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
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
