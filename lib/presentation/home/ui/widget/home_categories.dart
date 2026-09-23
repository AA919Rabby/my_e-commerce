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
      // Track selectedCategoryId here so Obx listens to changes
      final String selectedId = controller.selectedCategoryId.value;

      return SizedBox(
        height: 60.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1,
          separatorBuilder: (context, index) {
            return const Gap(12);
          },
          itemBuilder: (context, index) {
            // ============================================================
            // ALL - MANUAL CATEGORY
            // ============================================================

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

            // ============================================================
            // API CATEGORY
            // ============================================================

            final Result category = categories[index - 1];

            final String categoryId =
                category.id ?? '';

            final bool isSelected = selectedId == categoryId;

            return _CategoryItem(
              title: category.name ?? 'Category',
              icon: _getCategoryIcon(category.name),
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

  // ========================================================================
  // CATEGORY ICON
  // ========================================================================

  IconData _getCategoryIcon(String? name) {
    final String categoryName =
    (name ?? '').toLowerCase();

    if (categoryName.contains('electronic')) {
      return Icons.devices_rounded;
    }

    if (categoryName.contains('phone') ||
        categoryName.contains('mobile')) {
      return Icons.phone_android_rounded;
    }

    if (categoryName.contains('computer') ||
        categoryName.contains('laptop')) {
      return Icons.laptop_mac_rounded;
    }

    if (categoryName.contains('coffee') ||
        categoryName.contains('cup')) {
      return Icons.local_cafe_rounded;
    }

    if (categoryName.contains('fashion') ||
        categoryName.contains('cloth')) {
      return Icons.checkroom_rounded;
    }

    if (categoryName.contains('shoe')) {
      return Icons.directions_run_rounded;
    }

    if (categoryName.contains('car') ||
        categoryName.contains('vehicle')) {
      return Icons.directions_car_rounded;
    }

    if (categoryName.contains('home') ||
        categoryName.contains('furniture')) {
      return Icons.home_rounded;
    }

    if (categoryName.contains('book')) {
      return Icons.menu_book_rounded;
    }

    if (categoryName.contains('sport')) {
      return Icons.sports_soccer_rounded;
    }

    if (categoryName.contains('beauty') ||
        categoryName.contains('cosmetic')) {
      return Icons.face_retouching_natural_rounded;
    }

    if (categoryName.contains('food')) {
      return Icons.restaurant_rounded;
    }

    if (categoryName.contains('toy')) {
      return Icons.toys_rounded;
    }

    return Icons.category_rounded;
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
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,

        width: 60.w,
        height: 60.h,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          // ==============================================================
          // SELECTED = YELLOW
          // UNSELECTED = LIGHT
          // ==============================================================

          color: isSelected
              ? AppColor.drawerGradient1
              : Colors.white,

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
            // ============================================================
            // ICON
            // ============================================================

            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : AppColor.drawerGradient1,
            ),

            const Gap(5),

            // ============================================================
            // NAME
            // ============================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: CustomText(
                text: title,
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : AppColor.black,
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