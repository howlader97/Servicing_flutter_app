import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/models/notifications_model.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'provider/contractor_notification_provider.dart';

class ContractorAlertScreen extends ConsumerStatefulWidget {
  const ContractorAlertScreen({super.key});

  @override
  ConsumerState<ContractorAlertScreen> createState() =>
      _ContractorAlertScreenState();
}

class _ContractorAlertScreenState extends ConsumerState<ContractorAlertScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contractorNotificationProvider);
    final notifications = state.notifications;

    // Group notifications by dateGroup
    final today = DateTime.now();
    final todayNotifications = notifications.where((n) {
      return n.createdAt.year == today.year &&
          n.createdAt.month == today.month &&
          n.createdAt.day == today.day;
    }).toList();

    final lastWeekNotifications = notifications.where((n) {
      final isToday =
          n.createdAt.year == today.year &&
          n.createdAt.month == today.month &&
          n.createdAt.day == today.day;
      return !isToday;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar / Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  top: 20.0,
                  bottom: 10.0,
                  right: 18.0,
                ),
                child: Row(
                  children: [
                    AppText(
                      text: "Alerts",
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: AppColors.instance.textHeading,
                    ),
                    const Spacer(),
                    if (notifications.any((n) => !n.isRead))
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(contractorNotificationProvider.notifier)
                              .markAllAsRead();
                        },
                        child: AppText(
                          text: "Mark all as read",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.instance.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (state.isLoading && notifications.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.instance.primary,
                    ),
                  ),
                ),
              )
            else if (notifications.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: AppText(
                      text: "No alerts found",
                      fontSize: 16,
                      color: AppColors.instance.gray52,
                    ),
                  ),
                ),
              )
            else ...[
              // "Today" Section
              if (todayNotifications.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 18.0,
                      top: 16.0,
                      bottom: 8.0,
                    ),
                    child: AppText(
                      text: "Today",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7A8D),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = todayNotifications[index];
                    return _NotificationCard(
                      item: item,
                      onTap: () {
                        ref
                            .read(contractorNotificationProvider.notifier)
                            .markSingleAsRead(item.id);
                        if (item.data.jobId != null &&
                            item.data.jobId!.isNotEmpty) {
                          AppRoutes.instance.push(
                            AppRoutesKey.instance.contractJobDetailsScreen,
                            extra: {
                              "jobId": item.data.jobId,
                            },
                          );
                        } else {
                          AppSnackBar.instance
                              .error("Job details not found");
                        }
                      },
                    );
                  }, childCount: todayNotifications.length),
                ),
              ],

              // "Last week" Section
              if (lastWeekNotifications.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 18.0,
                      top: 20.0,
                      bottom: 8.0,
                    ),
                    child: AppText(
                      text: "Last week",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7A8D),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = lastWeekNotifications[index];
                    return _NotificationCard(
                      item: item,
                      onTap: () {
                        ref
                            .read(contractorNotificationProvider.notifier)
                            .markSingleAsRead(item.id);
                        if (item.data.jobId != null &&
                            item.data.jobId!.isNotEmpty) {
                          AppRoutes.instance.push(
                            AppRoutesKey.instance.contractJobDetailsScreen,
                            extra: {
                              "jobId": item.data.jobId,
                            },
                          );
                        } else {
                          AppSnackBar.instance
                              .error("Job details not found");
                        }
                      },
                    );
                  }, childCount: lastWeekNotifications.length),
                ),
              ],
            ],

            // Bottom Spacing to clear the floating bottom navigation bar
            const SliverToBoxAdapter(child: Gap(height: 120)),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unreadBgColor = const Color(0xFFEBF3FC);
    final readBgColor = AppColors.instance.white;
    final avatarUrl =
        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: item.isRead ? readBgColor : unreadBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.instance.borderColor.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with a premium colored outer border
                Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.isRead
                          ? Colors.grey.withValues(alpha: 0.3)
                          : AppColors.instance.primary,
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(avatarUrl),
                    backgroundColor: AppColors.instance.white500,
                  ),
                ),
                const Gap(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: item.title,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.instance.textHeading,
                        maxLines: 1,
                      ),
                      const Gap(height: 4),
                      AppText(
                        text: item.body,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.textColor.withValues(
                          alpha: 0.7,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                // Unread Green Dot
                if (!item.isRead) ...[
                  const Gap(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.instance.success, // Green color dot
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
