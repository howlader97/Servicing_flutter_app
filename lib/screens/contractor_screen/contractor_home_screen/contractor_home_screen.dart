import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/navigation_provider.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_home_screen/widgets/activity_card.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/widgets/overview_box.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/provider/profile_provider.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_home_screen/provider/contractor_dashboard_provider.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_home_screen/provider/contractor_recent_activity_provider.dart';
import 'package:flutter_riverpod_template/models/recent_activity_model.dart';
import '../../housing_manager_screen/housing_manager_home_screen/widgets/custome_header.dart';

class ContractorHomeScreen extends ConsumerWidget {
  const ContractorHomeScreen({super.key});

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
          AppRoutes.instance.push(
            AppRoutesKey.instance.contractJobDetailsScreen,
            extra: {
              "jobId": activity.id,
              "buttonTitle": activity.status,
            },
          );
        },
        title: buttonTitle,
        borderRadius: BorderRadius.circular(45),
        backgroundColor: AppColors.instance.transparent,
        titleColor: statusColor,
        borderColor: statusColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(contractorDashboardProvider);
    final recentActivityAsync = ref.watch(contractorRecentActivityProvider);
    final profile= ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomHeader(
              title: 'Welcome back',
              name: profile.value?.data.user.name  ?? 'no name',
              onTap: () {
                ref.read(navigationProvider.notifier).state = 2;
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
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
                  dashboardAsync.when(
                    data: (dashBoard) {
                      return Row(
                        children: [
                          Expanded(
                            child: OverviewBox(
                              subtext: 'jobs',
                              text: '${dashBoard?.data.totalJobs ?? 0}',
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
                              subtext: 'Finish job',
                              text: '${dashBoard?.data.jobs.total ?? 0}',
                              child: Image.asset(
                                AppAssertsIconsPath.instance.jobIcon,
                                color: AppColors.instance.white,
                                scale: 4,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, _) => Center(child: Text("Error: $error")),
                    loading: () => Shimmer.fromColors(
                      baseColor: AppColors.instance.grayE2,
                      highlightColor: AppColors.instance.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: OverviewBox(
                              subtext: 'jobs',
                              text: '0',
                              child: Container(
                                width: 24,
                                height: 24,
                                color: AppColors.instance.white,
                              ),
                            ),
                          ),
                          Gap(width: 10),
                          Expanded(
                            child: OverviewBox(
                              subtext: 'Finish job',
                              text: '0',
                              child: Container(
                                width: 24,
                                height: 24,
                                color: AppColors.instance.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                          GestureDetector(
                            onTap: () {
                              ref.read(navigationProvider.notifier).state = 1;
                            },
                            child: AppText(
                              text: "View all",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.instance.primary,
                            ),
                          ),
                        ],
                      ),
                      Gap(height: 18),
                      recentActivityAsync.when(
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
                                if (i > 0) Gap(height: 10),
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
