import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_contractor_info/provider/housing_contractor_provider.dart';


class HousingContractorInfo extends ConsumerStatefulWidget {
  const HousingContractorInfo({super.key});

  @override
  ConsumerState<HousingContractorInfo> createState() => _HousingContractorInfoState();
}

class _HousingContractorInfoState extends ConsumerState<HousingContractorInfo> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(housingContractorProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: Column(
        children: [
          // Custom Header Area
          Padding(
            padding: EdgeInsets.only(
              top: statusBarHeight + 10,
              left: 16,
              right: 16,
              bottom: 12,
            ),
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
                AppText(
                  text: "Contractor",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.instance.textHeading,
                ),
              ],
            ),
          ),

          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Search Input Field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.instance.grayE2.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.instance.grayE2,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.instance.gray50,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            style: TextStyle(
                              color: AppColors.instance.textHeading,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search by Name Or Category",
                              hintStyle: TextStyle(
                                color: AppColors.instance.gray50,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.instance.gray50,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayE2.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.instance.grayE2,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: AppColors.instance.textHeading,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // ListView of Contractor Cards
          Expanded(
            child: Builder(
              builder: (context) {
                final state = ref.watch(housingContractorProvider);
                final contractors = state.contractors;

                if (contractors.isEmpty && state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = contractors.where((c) {
                  final name = c.user.name.toLowerCase();
                  final category = (c.specialty ?? c.companyName ?? '').toLowerCase();
                  return name.contains(_searchQuery.toLowerCase()) ||
                      category.contains(_searchQuery.toLowerCase());
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: AppColors.instance.gray50,
                        ),
                        const SizedBox(height: 12),
                        AppText(
                          text: state.error ?? "No contractors found",
                          color: AppColors.instance.gray50,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 30,
                  ),
                  itemCount: filtered.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filtered.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final contractor = filtered[index];
                    
                    // Handle all fields null-safely with robust professional defaults
                    final String name = contractor.user.name.trim().isEmpty 
                        ? "Unnamed Contractor" 
                        : contractor.user.name;
                    
                    final String category = (contractor.specialty != null && contractor.specialty!.trim().isNotEmpty)
                        ? contractor.specialty!
                        : (contractor.companyName != null && contractor.companyName!.trim().isNotEmpty)
                            ? contractor.companyName!
                            : "General Contractor";

                    final String phone = contractor.user.phone.trim().isEmpty 
                        ? "No Phone Number" 
                        : contractor.user.phone;

                    final String email = contractor.user.email.trim().isEmpty 
                        ? "No Email Address" 
                        : contractor.user.email;

                    final String rating = contractor.rating == 0 
                        ? "0.0" 
                        : contractor.rating.toString();

                    final String imageUrl = (contractor.user.avatarUrl != null && contractor.user.avatarUrl!.trim().isNotEmpty)
                        ? contractor.user.avatarUrl!
                        : "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800";

                    return ContractorCard(
                      name: name,
                      category: category,
                      phone: phone,
                      email: email,
                      rating: rating,
                      imageUrl: imageUrl,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContractorCard extends StatelessWidget {
  final String name;
  final String category;
  final String phone;
  final String email;
  final String rating;
  final String imageUrl;

  const ContractorCard({
    super.key,
    required this.name,
    required this.category,
    required this.phone,
    required this.email,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.instance.grayE2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.instance.grayE2.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 170,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.instance.white500,
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: AppColors.instance.black300,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Name and Star Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: name,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.instance.textHeading,
              ),
              // Interactive Star Rating Widget
              GestureDetector(
                onTap: () {
                  AppRoutes.instance.pushNamed(
                    AppRoutesKey.instance.housingContractorReview,
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        text: rating,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.instance.textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Key-Value details
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "Category: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.instance.textHeading,
                    ),
                  ),
                  TextSpan(
                    text: category,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "Phone: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.instance.textHeading,
                    ),
                  ),
                  TextSpan(
                    text: phone,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "Email: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.instance.textHeading,
                    ),
                  ),
                  TextSpan(
                    text: email,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Assign Button at the bottom
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Show a modern high-fidelity success feedback snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    content: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.instance.success,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.instance.success.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.instance.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppText(
                              text: "Contractor assigned successfully!",
                              color: AppColors.instance.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.instance.primary,
                foregroundColor: AppColors.instance.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: AppText(
                text: "Assign",
                color: AppColors.instance.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

