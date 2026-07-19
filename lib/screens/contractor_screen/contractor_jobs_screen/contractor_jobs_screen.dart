import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/navigation_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/widgets/custom_container.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_jobs_screen/provider/contractor_jobs_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/provider/profile_provider.dart';
import '../../../utils/app_snack_bar.dart';
import '../../housing_manager_screen/housing_manager_home_screen/widgets/custome_header.dart';
import '../contract_job_details_screen/provider/contractor_job_action_provider.dart';
import '../contract_job_details_screen/provider/contractor_job_details_provider.dart';

class ContractorJobsScreen extends ConsumerStatefulWidget {
  const ContractorJobsScreen({super.key});

  @override
  ConsumerState<ContractorJobsScreen> createState() =>
      _ContractorJobsScreenState();
}

class _ContractorJobsScreenState extends ConsumerState<ContractorJobsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(contractorJobsProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contractorJobsProvider);
    final profile = ref.watch(profileProvider);
    final jobs = state.jobs;

    List<String> projectValue = [
      "New job",
      "Decline job",
      "Accept job",
      "Complete job",
    ];
    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: CustomHeader(
              title: 'Welcome back',
              name: profile.value?.data.user.name ?? '',
              isSearch: true,
              onTap: () {
                ref
                    .read(navigationProvider.notifier)
                    .state = 2;
              },
              filterItems: projectValue,
              onFilterSelected: (value) {},
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: jobs.isEmpty && state.isLoading
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.instance.primary,
                  ),
                ),
              )
                  : jobs.isEmpty
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Text(
                    state.error ?? "No jobs found",
                    style: TextStyle(
                      color: state.error != null
                          ? Colors.red
                          : AppColors.instance.gray52,
                    ),
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: jobs.length + (state.isLoading ? 1 : 0),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == jobs.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.instance.primary,
                        ),
                      ),
                    );
                  }
                  final job = jobs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CustomContainer(
                        color: AppColors.instance.grayE2,
                        isCompleteButton:
                        job.status == "PENDING" ||
                            job.status == "IN_PROGRESS"
                            ? true
                            : false,

                        isContractor: true,
                        buttonTitle: job.status == "PENDING"
                            ? "accept"
                            : "Complete",
                        acceptButton: job.status == "PENDING"
                            ? () async {
                          final success =
                          await ref.read(contractorJobActionProvider.notifier).acceptJob(job.id);
                          if (success) {
                            AppSnackBar.instance
                                .success("Job accepted successfully");
                            ref.invalidate(
                                contractorJobDetailsProvider(job.id));
                            ref
                                .read(contractorJobsProvider.notifier)
                                .refresh();
                          } else {
                            AppSnackBar.instance
                                .error("Failed to accept job");
                          }
                        }
                            : job.status == "IN_PROGRESS"
                            ? () {
                          AppRoutes.instance.push(
                            AppRoutesKey.instance.contractJobEvidenceScreen,
                            extra: job.id,
                          );
                        }
                            : null,

                        contractButton: ()
                    {
                    AppRoutes.instance.push(
                    AppRoutesKey.instance.contractJobDetailsScreen,
                    extra: {
                    "jobId": job.id,
                    },
                    );
                    },
                    isStatus: true,
                    imageUrl: job.images.isNotEmpty
                        ? job.images[0].imageUrl
                        : 'https://5.imimg.com/data5/BZ/GN/TG/SELLER-2473645/water-taps-1000x1000.jpg',
                    issueName: job.title,
                    propertyId: '#${job.property.propertyCode}',
                    propertyLocation: job.property.location,
                    status: job.status,

                    community: true,
                    communityName:
                    "${job.createdAt.hour.toString().padLeft(2, '0')}:${job
                        .createdAt.minute.toString().padLeft(2, '0')}",
                    jobCreateTime: "${job.startedAt}",
                    jobStatus: job.status,
                  ),);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
