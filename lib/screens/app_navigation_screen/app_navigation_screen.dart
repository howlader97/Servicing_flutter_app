import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/navigation_provider.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_alert_screen/contractor_allert_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_home_screen/contractor_home_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_jobs_screen/contractor_jobs_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_profile_screen/contractor_profile_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_assets_screen/housing_manager_assets_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/housing_manager_home_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_job_screen/housing_manager_job_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/housing_manager_profile_screen.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/user_role_provider.dart';

class AppNavigationScreen extends ConsumerWidget {
  const AppNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
    final userRole = ref.watch(userRoleProvider);

    final List<Widget> pages;
    final List<String> labels;
    final List<String> icons;

    if (userRole == "CONTRACTOR") {
      pages = const [
        ContractorHomeScreen(),
        ContractorJobsScreen(),
        ContractorAlertScreen(),
        ContractorProfileScreen(),
      ];
      labels = const ["Home", "Jobs", "Alerts", "Profile"];
      icons = [
        AppAssertsIconsPath.instance.homeIcon,
        AppAssertsIconsPath.instance.jobIcon,
        AppAssertsIconsPath.instance.notificationIcon,
        AppAssertsIconsPath.instance.userIcon,
      ];
    } else {
      pages = const [
        HousingManagerHomeScreen(),
        HousingManagerJobScreen(),
        HousingManagerAssetsScreen(),
        HousingManagerProfileScreen(),
      ];
      labels = const ["Home", "Jobs", "Assets", "Profile"];
      icons = [
        AppAssertsIconsPath.instance.homeIcon,
        AppAssertsIconsPath.instance.jobIcon,
        AppAssertsIconsPath.instance.assetsIcon,
        AppAssertsIconsPath.instance.userIcon,
      ];
    }

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,

      body: pages[currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE2E7ED),
          borderRadius: BorderRadius.circular(45),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final isSelected = currentIndex == index;

            return GestureDetector(
              onTap: () {
                ref.read(navigationProvider.notifier).state = index;
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: isSelected
                      ? AppColors.instance.bottomColor
                      : Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    width: AppSize.width(value: 37),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          scale: 4,
                          icons[index],
                          color: AppColors.instance.textHeading,
                        ),
                        const SizedBox(height: 3),
                        AppText(
                          text: labels[index],
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.instance.textHeading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
