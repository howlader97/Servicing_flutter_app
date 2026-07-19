import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';

import '../../constant/app_constant.dart';
import '../texts/app_text.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final String status;
  final bool? isStatus;

  const ImageSlider({super.key,
    required this.images,
    required this.status,
    this.isStatus = false});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.blueGrey.withValues(alpha: 0.12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.instance.white500,
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: AppColors.instance.black300,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if(widget.isStatus == true)...[
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.instance.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText(
                  text: widget.status,
                  color: AppColors.instance.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppConstant.instance.libreFranklin,
                ),
              ),
            ),
          ],

          if (_currentPage > 0)
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.instance.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.instance.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          // Right chevron arrow (Forward)
          if (_currentPage < widget.images.length - 1)
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.instance.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.instance.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          // Indicator dots at bottom center
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 6.0,
                  width: _currentPage == index ? 24.0 : 24.0,
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
    );
  }
}