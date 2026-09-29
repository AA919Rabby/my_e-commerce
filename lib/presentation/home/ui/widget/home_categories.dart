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
        height: 67.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1,
          separatorBuilder: (context, index) {
            return const Gap(12);
          },
          itemBuilder: (context, index) {
            // ALL - MANUAL CATEGORY
            if (index == 0) {
              final bool isSelected = selectedId == 'All';

              return _CategoryItem(
                title: 'All',
                icon: Icons.shopify_outlined,
                isSelected: isSelected,
                onTap: () {
                  controller.selectCategory('All');
                },
              );
            }

            // API CATEGORY
            final Result category = categories[index - 1];

            // Note: If your API filters categories by their ID instead of their Name,
            // you might need to change this to: `category.id?.toString() ?? ''`
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

    if (value.contains('makeup') ||
        value.contains('beauty')) {
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

// ============================================================================
// CATEGORY ITEM
// ============================================================================
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        padding: EdgeInsets.all(2.sp),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 67.w,
        height: 67.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColor.drawerGradient1 : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColor.drawerGradient1
                : AppColor.drawerGradient1.withOpacity(0.30),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColor.drawerGradient1.withOpacity(0.35)
                  : Colors.black.withOpacity(0.06),
              blurRadius: isSelected ? 12 : 5,
              spreadRadius: isSelected ? 1 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25,
              color: isSelected ? Colors.white : AppColor.drawerGradient1,
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomText(
                text: title,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColor.black,
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