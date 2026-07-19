import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_create_job_screen/provider/create_job_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_create_job_screen/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_dropdown_field.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/widgets/image_userPick/image_user_pick.dart';
import 'package:flutter_riverpod_template/screens/auth/sign_up_screen/provider/sign_up_provider.dart';
import 'package:flutter_riverpod_template/models/service_name_model.dart';
import 'package:flutter_riverpod_template/widgets/buttons/drop_down.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_contractor_info/provider/housing_contractor_provider.dart';
import 'package:flutter_riverpod_template/models/all_contractors_model.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_assets_screen/provider/housing_property.dart';
import 'package:flutter_riverpod_template/models/property_response.dart';

class HousingCreateJobScreen extends ConsumerStatefulWidget {
  const HousingCreateJobScreen({super.key});

  @override
  ConsumerState<HousingCreateJobScreen> createState() =>
      _HousingCreateJobScreenState();
}

class _HousingCreateJobScreenState
    extends ConsumerState<HousingCreateJobScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _tenantNumberController = TextEditingController();

  final List<String> _priorities = ['LOW', 'MEDIUM', 'HIGH', 'URGENT'];


  final List<String> _photos = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tenantNameController.dispose();
    _tenantNumberController.dispose();
    super.dispose();
  }



  void _pickPhoto() {
    appImageUserTake(
      callBack: (String path) {
        if (path.isNotEmpty) {
          setState(() {
            _photos.add(path);
          });
        }
      },
    );
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  void _submit({
    required ServiceCategory? selectedCategory,
    required Contractor? selectedAssignee,
    required String selectedPriority,
    required Property? selectedProperty,
  }) {

    if (_titleController.text.trim().isEmpty) {
      AppSnackBar.instance.error('Please enter a title');
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      AppSnackBar.instance.error('Please enter a description');
      return;
    }
    if (selectedCategory == null) {
      AppSnackBar.instance.error('Please select an issue category');
      return;
    }
    if (selectedProperty == null) {
      AppSnackBar.instance.error('Please select a property');
      return;
    }
    if (_tenantNameController.text.trim().isEmpty) {
      AppSnackBar.instance.error('Please enter the tenant name');
      return;
    }
    if (_tenantNumberController.text.trim().isEmpty) {
      AppSnackBar.instance.error('Please enter the tenant phone number');
      return;
    }


    ref.read(createJobProvider.notifier).submit(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          propertyId: selectedProperty.id,
          issueId: selectedCategory.id,
          priority: selectedPriority,
          assignedToId: selectedAssignee?.id,
          tenantName: _tenantNameController.text.trim(),
          tenantPhone: _tenantNumberController.text.trim(),
          photos: List<String>.from(_photos),
        );
  }



  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(jobCategoryProvider);
    final selectedAssignee = ref.watch(jobAssigneeProvider);
    final selectedPriority = ref.watch(jobPriorityProvider);
    final servicesAsync = ref.watch(servicesProvider);
    final contractorsState = ref.watch(housingContractorProvider);
    final propertyAsync = ref.watch(housingPropertyProvider);
    final selectedProperty = ref.watch(jobPropertyProvider);

    final isLoading = ref.watch(createJobProvider) is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: CustomAppBar(title: 'New job create')),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  servicesAsync.when(
                    data: (services) => DropdownField<ServiceCategory>(
                      title: 'Issue category',
                      hintText: 'Select category',
                      value: selectedCategory,
                      options: services,
                      itemLabel: (e) => e.name,
                      onChanged: (val) {
                        ref.read(jobCategoryProvider.notifier).state = val;
                      },
                    ),
                    loading: () => _buildShimmerField(),
                    error: (_, __) => _buildFieldError('Error loading categories'),
                  ),


                  AppInputWidgetTwo(
                    title: 'Title',
                    hintText: 'Enter job title',
                    minLines: 1,
                    controller: _titleController,
                  ),


                  AppInputWidgetTwo(
                    title: 'Description',
                    hintText: "Tell us what's broken...",
                    minLines: 4,
                    controller: _descriptionController,
                  ),

                  const Gap(height: 10),

                  if (contractorsState.isLoading &&
                      contractorsState.contractors.isEmpty)
                    _buildShimmerField()
                  else if (contractorsState.error != null &&
                      contractorsState.contractors.isEmpty)
                    _buildFieldError('Error loading contractors')
                  else
                    DropdownField<Contractor>(
                      title: 'Assign to (optional)',
                      hintText: 'Select contractor',
                      value: selectedAssignee,
                      options: contractorsState.contractors,
                      itemLabel: (e) => e.companyName ?? e.user.name,
                      onChanged: (val) {
                        ref.read(jobAssigneeProvider.notifier).state = val;
                      },
                    ),


                  AppDropdownField(
                    title: 'Priority level',
                    provider: jobPriorityProvider,
                    options: _priorities,
                  ),


                  propertyAsync.when(
                    data: (response) {
                      final properties = response?.data.properties ?? [];
                      return DropdownField<Property>(
                        title: 'Property location',
                        hintText: 'Select property location',
                        value: selectedProperty,
                        options: properties,
                        itemLabel: (e) => e.location,
                        onChanged: (val) {
                          ref.read(jobPropertyProvider.notifier).state = val;
                        },
                      );
                    },
                    loading: () => _buildShimmerField(),
                    error: (_, __) =>
                        _buildFieldError('Error loading properties'),
                  ),

                  AppInputWidgetTwo(
                    title: 'Tenant name',
                    hintText: 'Mira Khan',
                    controller: _tenantNameController,
                  ),
                  AppInputWidgetTwo(
                    title: 'Tenant phone',
                    hintText: '1234567890',
                    controller: _tenantNumberController,
                  ),


                  _buildPhotoSection(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                    child: AppButton(
                      height: 44,
                      title: 'Submit Request',
                      isLoading: isLoading,
                      onTap: () => _submit(
                        selectedCategory: selectedCategory,
                        selectedAssignee: selectedAssignee,
                        selectedPriority: selectedPriority,
                        selectedProperty: selectedProperty,
                      ),
                    ),
                  ),

                  const Gap(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Photo section ──────────────────────────────────────────────────────────

  Widget _buildPhotoSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(height: 15),
          AppText(
            text: 'Upload photos',
            fontWeight: FontWeight.w500,
            color: AppColors.instance.black900,
            fontSize: 18,
          ),
          const Gap(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // ── Existing photos ─────────────────────────────────────────
              ..._photos.asMap().entries.map((entry) {
                final int index = entry.key;
                final String path = entry.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.instance.white500,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: AppColors.instance.black300,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:
                                AppColors.instance.error.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 12,
                            color: AppColors.instance.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              // ── Add photo button ────────────────────────────────────────
              GestureDetector(
                onTap: _pickPhoto,
                child: CustomPaint(
                  painter: _DashedBorderPainter(
                    color:
                        AppColors.instance.borderColor.withValues(alpha: 0.5),
                    borderRadius: 12,
                  ),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.instance.white500,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 28,
                          color: AppColors.instance.black300,
                        ),
                        const Gap(height: 4),
                        AppText(
                          text: 'Add',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.instance.black300,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(height: 4),
        ],
      ),
    );
  }

  // ── Reusable shimmer / error helpers ────────────────────────────────────────

  Widget _buildShimmerField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
      child: Shimmer.fromColors(
        baseColor: AppColors.instance.grayE2,
        highlightColor: AppColors.instance.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(height: 15),
            Container(
              width: 120.0,
              height: 18.0,
              decoration: BoxDecoration(
                color: AppColors.instance.white,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            const Gap(height: 10),
            Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: AppColors.instance.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldError(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: AppText(
        text: message,
        color: AppColors.instance.error,
      ),
    );
  }
}

// ── Dashed border painter ──────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  const _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = Path();
    double distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.gap != gap ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.borderRadius != borderRadius;
}
