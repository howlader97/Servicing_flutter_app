import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class HousingContractorReviewScreen extends StatelessWidget {
  const HousingContractorReviewScreen({super.key});

  final List<Map<String, dynamic>> _reviews = const [
    {
      "name": "Eleanor Summers",
      "date": "Today, 16:40",
      "rating": 5,
      "comment": "What can I say it's fast food, it's Burger King.No different to any of the other burger kings, nice with adequate seating",
      "avatarUrl": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
    },
    {
      "name": "Victoria Champain",
      "date": "Today, 09:12",
      "rating": 5,
      "comment": "Food, as always, is good both upstairs and downstairs is always clean (download the bk app for deals etc.) sit upstairs every time, more relaxed feel.",
      "avatarUrl": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150",
    },
    {
      "name": "Laura Smith",
      "date": "Yesterday, 16:40",
      "rating": 5,
      "comment": "Amazing food. Lots of choice. We took a while to choose as everything sounded amazing on the menu! All cooked to perfection. Portions were large. Service excellent. Definitely plan to go again and often!",
      "avatarUrl": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150",
    },
    {
      "name": "Dora Perry",
      "date": "Yesterday, 16:40",
      "rating": 5,
      "comment": "I popped in for a late lunch on Friday after a long morning working. The staff member was rude and unhelpful and the toilets were closed. I will not be returning and suggest others do not either.",
      "avatarUrl": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: Column(
        children: [
          // Header Bar
          Padding(
            padding: EdgeInsets.only(
              top: statusBarHeight + 10,
              left: 16,
              right: 16,
              bottom: 16,
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
                const Gap(width: 14),
                AppText(
                  text: "review", // Lowercase matching the mockup exactly
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.instance.textHeading,
                ),
              ],
            ),
          ),

          // Reviews List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 30,
              ),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          ClipOval(
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Image.network(
                                review["avatarUrl"],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppColors.instance.primary.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.instance.primary,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Gap(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Reviewer name and Date
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        text: review["name"],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.instance.textHeading,
                                      ),
                                    ),
                                    AppText(
                                      text: review["date"],
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.instance.gray50,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),

                                // Five star icons row
                                Row(
                                  children: List.generate(
                                    review["rating"],
                                    (idx) => const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Multi-line review description commentary text
                                AppText(
                                  text: review["comment"],
                                  fontSize: 14,
                                  height: 1.45,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.instance.textColor,
                                  maxLines: 100,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divider matching the mockup styling
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: AppColors.instance.grayE2.withValues(alpha: 0.6),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
