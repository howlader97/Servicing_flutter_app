import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import '../../../../constant/app_asserts_icons_path.dart';
import '../../../../widgets/buttons/icon_button_widget.dart';
import '../../../../widgets/texts/app_text.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String name;
  final bool? isSearch;
  final VoidCallback? onTap;
  final bool isFilter;
  final List<String>? filterItems;
  final ValueChanged<String>? onFilterSelected;

  const CustomHeader({
    super.key,
    required this.title,
    required this.name,
     this.isSearch = false,  this.onTap,
    this.isFilter =true,
    this.filterItems,
    this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.instance.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          top: AppSize.height(value: 65),
          right: 18,
          bottom: 22
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.instance.gray52,
                    ),
                    Gap(height: 4),
                    AppText(
                      text: name,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.instance.textHeading,
                    ),
                  ],
                ),
                Spacer(),
                IconButtonWidget(
                  onTap: onTap,
                  color: AppColors.instance.gray52,
                  child: Image.asset(
                    AppAssertsIconsPath.instance.notificationIcon,
                    color: AppColors.instance.white,
                    scale: 4,
                  ),
                ),
              ],
            ),
            if(isSearch == true)...[
              const Gap(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.instance.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.instance.textHeading,
                      size: 22,

                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: AppColors.instance.textHeading,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search by name, location",
                          hintStyle: TextStyle(
                            color: AppColors.instance.textHeading,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (isFilter)
                      PopupMenuButton<String>(
                        onSelected: onFilterSelected,
                        itemBuilder: (context) {
                          return (filterItems ?? [])
                              .map(
                                (item) => PopupMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          )
                              .toList();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.instance.textColor.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.filter_alt_outlined,
                            color: AppColors.instance.textColor,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}