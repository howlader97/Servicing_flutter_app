import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/navigation_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/provider/housing_dashBoard_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/provider/housing_issue_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/widgets/custom_container.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/widgets/custome_header.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/widgets/overview_box.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/provider/profile_provider.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

import '../../../widgets/buttons/app_button.dart';
import '../../contractor_screen/contractor_home_screen/widgets/activity_card.dart';
import 'package:flutter_riverpod_template/models/all_jobs_model.dart' as jobs_model;
import 'package:flutter_riverpod_template/models/recent_activity_model.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/provider/housing_recent_activity_provider.dart';
import 'package:shimmer/shimmer.dart';

class HousingManagerHomeScreen extends ConsumerStatefulWidget {
  const HousingManagerHomeScreen({super.key});

  @override
  ConsumerState<HousingManagerHomeScreen> createState() =>
      _HousingManagerHomeScreenState();
}

class _HousingManagerHomeScreenState extends ConsumerState<HousingManagerHomeScreen> {
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
      ref.read(housingIssueProvider.notifier).fetchNextPage();
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years yr${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months mo${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  Widget _buildActivityCard(Activity activity) {
    Color statusColor;
    String buttonTitle = activity.status;

    switch (activity.status.toUpperCase()) {
      case 'IN_PROGRESS':
        statusColor = AppColors.instance.primary;
        buttonTitle = 'inProgress';
        break;
      case 'COMPLETE':
      case 'COMPLETED':
        statusColor = Colors.green;
        buttonTitle = 'Complete';
        break;
      case 'PENDING':
        statusColor = Colors.amber;
        buttonTitle = 'Pending';
        break;
      default:
        statusColor = AppColors.instance.primary;
    }

    final timeAgo = _getTimeAgo(activity.updatedAt);
    final subtitle =
        '${activity.property.propertyCode.isNotEmpty ? 'unit ${activity.property.propertyCode} • ' : ''}$timeAgo';

    return ActivityCard(
      title: activity.title,
      subtitle: subtitle,
      child: AppButton(
        onTap: () {
          final job = jobs_model.Job(
            id: activity.id,
            jobNumber: '',
            title: activity.title,
            description: '',
            status: activity.status,
            priority: '',
            propertyId: activity.property.propertyCode,
            issueId: '',
            assignedToId: '',
            createdById: '',
            scheduledDate: DateTime.now(),
            startedAt: DateTime.now(),
            completedAt: null,
            estimatedCost: 0,
            actualCost: 0,
            notes: null,
            tenantName: null,
            tenantPhone: null,
            createdAt: activity.updatedAt,
            updatedAt: activity.updatedAt,
            property: jobs_model.Property(
              propertyCode: activity.property.propertyCode,
              location: activity.property.location,
            ),
            assignedTo: jobs_model.AssignedTo(
              id: '',
              userId: '',
              companyName: '',
              specialty: '',
              licenseNo: '',
              rating: 0,
              totalJobs: 0,
              user: jobs_model.User(
                name: '',
                avatarUrl: null,
              ),
            ),
            images: [],
            count: jobs_model.JobCount(images: 0),
          );
          AppRoutes.instance.pushNamed(
            AppRoutesKey.instance.housingJobDetailsScreen,
            extra: job,
          );
        },
        title: buttonTitle,
        borderRadius: BorderRadius.circular(45),
        backgroundColor: AppColors.instance.transparent,
        titleColor: statusColor,
        borderColor: statusColor,
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () => AppRoutes.instance.pushNamed(
                AppRoutesKey.instance.housingManagerNotificationScreen,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer(
              builder: (context, ref, child) {
                final dashBoardAsync = ref.watch(housingDashBoardProvider);
                return dashBoardAsync.when(
                  data: (dashBoard) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Overview",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.instance.textHeading,
                          ),
                          Gap(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OverviewBox(
                                  subtext: 'jobs',
                                  text: '${dashBoard?.data.jobs.total ?? 0}',
                                  child: Image.asset(
                                    AppAssertsIconsPath.instance.jobIcon,
                                    scale: 4,
                                    color: AppColors.instance.white,
                                  ),
                                ),
                              ),
                              Gap(width: 10),
                              Expanded(
                                child: OverviewBox(
                                  subtext: 'Pending jobs',
                                  text: "${dashBoard?.data.totalIssues ?? 0}",
                                  child: Image.asset(
                                    AppAssertsIconsPath
                                        .instance
                                        .pendingJobsIcon,
                                    scale: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Error: $error"),
                  ),
                  loading: () => Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.instance.grayE2,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 22,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                      Consumer(
                        builder: (context, ref, child) {
                          final issuesState = ref.watch(housingIssueProvider);
                          final issues = issuesState.issues;

                          if (issues.isEmpty && issuesState.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (issues.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              child: Center(
                                child: AppText(
                                  text: issuesState.error ?? "No issues found",
                                  fontSize: 16,
                                  color: AppColors.instance.gray52,
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Gap(height: 10,),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: issues.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final issue = issues[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        AppRoutes.instance.pushNamed(
                                          AppRoutesKey
                                              .instance
                                              .housingIssueDetailsScreen,
                                          extra: issue.id,
                                        );
                                      },
                                      child: CustomContainer(
                                        color: const Color(0xFFF5FAFF),
                                        imageUrl: (issue.images.isNotEmpty)
                                            ? issue.images[0]
                                            : '',
                                        issueName: issue.title,
                                        propertyId: issue.property.propertyCode,
                                        isStatus: true,
                                        propertyLocation:
                                            issue.property.location,
                                        status: issue.isResolved
                                            ? "complete"
                                            : "pending",
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (issuesState.isLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColors.instance.grayE2,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AppText(
                            text: "Recent activity",
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: AppColors.instance.textHeading,
                          ),
                          Spacer(),

                          Consumer(
                            builder: (context, ref, child) {
                              return GestureDetector(
                                onTap: () {
                                  ref.read(navigationProvider.notifier).state =
                                      1;
                                },
                                child: AppText(
                                  text: "View all",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.instance.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final recentActivityAsync =
                              ref.watch(housingRecentActivityProvider);
                          return recentActivityAsync.when(
                            data: (recentActivity) {
                              final activities =
                                  recentActivity?.data.activity ?? [];

                              final Map<String, Activity> uniqueRecentActivities = {};
                              for (var activity in activities) {
                                final statusUpper = activity.status.toUpperCase();
                                String key;
                                if (statusUpper == 'IN_PROGRESS') {
                                  key = 'IN_PROGRESS';
                                } else if (statusUpper == 'COMPLETE' || statusUpper == 'COMPLETED') {
                                  key = 'COMPLETED';
                                } else if (statusUpper == 'PENDING') {
                                  key = 'PENDING';
                                } else {
                                  key = statusUpper;
                                }

                                if (!uniqueRecentActivities.containsKey(key)) {
                                  uniqueRecentActivities[key] = activity;
                                }
                              }

                              final filteredActivities = uniqueRecentActivities.values.toList();
                              filteredActivities.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                              if (filteredActivities.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                  ),
                                  child: Center(
                                    child: AppText(
                                      text: "No recent activities found",
                                      fontSize: 16,
                                      color: AppColors.instance.gray52,
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: [
                                  for (int i = 0; i < filteredActivities.length; i++) ...[
                                    if (i > 0) const Gap(height: 10),
                                    _buildActivityCard(filteredActivities[i]),
                                  ],
                                ],
                              );
                            },
                            error: (error, _) => Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: Text(
                                  "Error: $error",
                                  style: TextStyle(
                                    color: AppColors.instance.error,
                                  ),
                                ),
                              ),
                            ),
                            loading: () => Shimmer.fromColors(
                              baseColor: AppColors.instance.bottomColor,
                              highlightColor: AppColors.instance.white,
                              child: Column(
                                children: List.generate(
                                  3,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: AppColors.instance.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const Gap(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 16,
                                              color: AppColors.instance.white,
                                            ),
                                            const Gap(height: 5),
                                            Container(
                                              width: 80,
                                              height: 12,
                                              color: AppColors.instance.white,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: 80,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.instance.white,
                                            borderRadius: BorderRadius.circular(45),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
