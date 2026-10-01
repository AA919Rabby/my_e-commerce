import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../global/custom_text.dart';
import '../../controller/home_controller.dart';
import '../../data/all_category_model.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      final categories = controller.allCategories;
      final String selectedId = controller.selectedCategoryId.value;

      return SizedBox(
        height: 82.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          itemCount: categories.length + 1,
          separatorBuilder: (context, index) {
            return Gap(14.w);
          },
          itemBuilder: (context, index) {
            if (index == 0) {
              final bool isSelected = selectedId == 'All';

              return _CategoryItem(
                title: 'All',
                icon: Icons.apps_rounded,
                isSelected: isSelected,
                onTap: () {
                  controller.selectCategory('All');
                },
              );
            }

            final Result category = categories[index - 1];

            final String categoryId = category.name ?? '';
            final bool isSelected = selectedId == categoryId;

            return _CategoryItem(
              title: category.name ?? 'Category',
              icon: _getCategoryIcon(categoryId),
              isSelected: isSelected,
              onTap: () {
                controller.selectCategory(categoryId);
              },
            );
          },
        ),
      );
    });
  }

  IconData _getCategoryIcon(String category) {
    final String value = category.toLowerCase();

    if (value.contains('hair')) {
      return Icons.content_cut_rounded;
    }

    if (value.contains('makeup') || value.contains('beauty')) {
      return Icons.face_retouching_natural;
    }

    if (value.contains('ac')) {
      return Icons.ac_unit_rounded;
    }

    if (value.contains('painting')) {
      return Icons.format_paint_rounded;
    }

    return Icons.home_repair_service_rounded;
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 52.h,
              width: 52.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColor.drawerGradient1
                    : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? AppColor.drawerGradient1
                      : AppColor.drawerGradient1.withOpacity(0.18),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColor.drawerGradient1.withOpacity(0.20)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 21.sp,
                color: isSelected
                    ? Colors.white
                    : AppColor.drawerGradient1,
              ),
            ),

            Gap(5.h),

            SizedBox(
              width: 68.w,
              child: CustomText(
                text: title,
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}