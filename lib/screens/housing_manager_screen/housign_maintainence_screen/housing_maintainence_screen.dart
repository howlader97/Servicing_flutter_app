import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housign_maintainence_screen/provider/housing_maintenance_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housign_maintainence_screen/widgets/maintenance_history_item.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_job_details_screen/widgets/details_row.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class HousingMaintenanceScreen extends ConsumerStatefulWidget {
  const HousingMaintenanceScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  ConsumerState<HousingMaintenanceScreen> createState() => _HousingMaintenanceScreenState();
}

class _HousingMaintenanceScreenState extends ConsumerState<HousingMaintenanceScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  final List<String> mockImages = [
    'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
    'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=800',
    'https://images.unsplash.com/photo-1615671524827-c1fe3973b648?w=800',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final asyncData = ref.watch(housingMaintenanceProvider(widget.propertyId));

    return asyncData.when(
      data: (details) {
        if (details == null) {
          return Scaffold(
            backgroundColor: AppColors.instance.bottomColor,
            body: const Center(
              child: AppText(text: "Property details not found"),
            ),
          );
        }

        final property = details.data.property;
        final maintenanceHistory = details.data.maintenanceHistory;
        final images = property.images.isNotEmpty
            ? property.images.map((e) => e.imageUrl).toList()
            : mockImages;

        return Scaffold(
          backgroundColor: AppColors.instance.bottomColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 330,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.instance.white500,
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  color: AppColors.instance.black300,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: statusBarHeight + 10,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            IconButtonWidget(
                              color: AppColors.instance.primary,
                              onTap: () => AppRoutes.instance.pop(),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.instance.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: AppText(
                                text: "House Maintenance History",
                                color: AppColors.instance.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (_currentPage > 0) {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _pageController.animateToPage(
                                  images.length - 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.instance.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: AppColors.instance.black900,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        right: 16,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (_currentPage < images.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.instance.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.instance.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 45,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              height: 6.0,
                              width: _currentPage == index ? 32.0 : 20.0,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? AppColors.instance.primary
                                    : AppColors.instance.gray52,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
                    decoration: BoxDecoration(
                      color: AppColors.instance.bottomColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // "Basic details" section header
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 10.0),
                          child: AppText(
                            text: "Basic details",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.instance.gray52,
                          ),
                        ),

                        // Basic details card container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          decoration: BoxDecoration(
                            color: AppColors.instance.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailRow(label: "Property ID", value: property.propertyCode),
                              DetailRow(label: "Property location", value: property.location),
                              DetailRow(label: "Community name", value: property.community?.name ?? "N/A"),
                              DetailRow(label: "Details", value: property.type),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // "Maintenance history" section header
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 10.0),
                          child: AppText(
                            text: "Maintenance history",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.instance.gray52,
                          ),
                        ),

                        // Maintenance history card container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.instance.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: maintenanceHistory.isEmpty
                                ? [
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: AppText(text: "No Maintenance History Found"),
                                      ),
                                    )
                                  ]
                                : List.generate(maintenanceHistory.length, (index) {
                                    final history = maintenanceHistory[index];
                                    return Column(
                                      children: [
                                        if (index > 0)
                                          const Divider(height: 24, thickness: 0.5, color: Colors.transparent),
                                        MaintenanceHistoryItem(
                                          title: history.title,
                                          dateAndType: "${history.date} · ${history.type}",
                                          price: history.price.startsWith("\$") ? history.price : "\$${history.price}",
                                        ),
                                      ],
                                    );
                                  }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (err, stack) => Scaffold(
        backgroundColor: AppColors.instance.bottomColor,
        body: Center(
          child: AppText(text: "Error: $err"),
        ),
      ),
      loading: () => Scaffold(
        backgroundColor: AppColors.instance.bottomColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}



