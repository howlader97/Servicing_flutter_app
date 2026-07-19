import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/widgets/custom_container.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_job_screen/provider/job_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/provider/profile_provider.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import '../housing_manager_home_screen/widgets/custome_header.dart';

class HousingManagerJobScreen extends ConsumerStatefulWidget {
  const HousingManagerJobScreen({super.key});

  @override
  ConsumerState<HousingManagerJobScreen> createState() =>
      _HousingManagerJobScreenState();
}

class _HousingManagerJobScreenState extends ConsumerState<HousingManagerJobScreen> {
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
      ref.read(jobProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> projectValue = ["inProgress", "complete", "pending"];
    final profile= ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: AppColors.instance.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: CustomHeader(
              title: 'Welcome back',
              name: profile.value?.data.user.name ?? 'no name',
              isSearch: true,
              onTap: () {
                AppRoutes.instance.push(
                  AppRoutesKey.instance.housingManagerNotificationScreen,
                );
              },
              filterItems: projectValue,
              onFilterSelected: (value) {},
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Row(
                children: [
                  AppText(
                    text: "My issues",
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.housingCreateJobScreen,
                      );
                    },
                    child: AppText(
                      text: "Create Job",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer(
              builder: (context, ref, child) {
                final jobState = ref.watch(jobProvider);
                final jobs = jobState.jobs;

                if (jobs.isEmpty && jobState.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (jobs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        jobState.error ?? "No data Found",
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Gap(height: 15,),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: jobs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = jobs[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CustomContainer(
                              color: AppColors.instance.grayE2,
                              isButton: true,
                              viewButton: () {
                                AppRoutes.instance.pushNamed(
                                  AppRoutesKey.instance.housingJobDetailsScreen,
                                  extra: data,
                                );
                              },
                              isStatus: true,
                              imageUrl: data.images.isNotEmpty
                                  ? data.images.last.imageUrl
                                  : '',
                              issueName: data.title,
                              propertyId: data.property.propertyCode,
                              propertyLocation: data.property.location,
                              status: data.status,
                            ),
                          );
                        },
                      ),
                      if (jobState.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
