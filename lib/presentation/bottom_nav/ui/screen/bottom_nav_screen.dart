import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/presentation/cart/ui/screen/cart_screen.dart';
import 'package:mye_commerce/presentation/favourite/ui/screen/favourite_screen.dart';
import 'package:mye_commerce/presentation/home/ui/screen/home_screen.dart';
import 'package:mye_commerce/presentation/profile/ui/screen/profile_screen.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../global/custom_text.dart';
import '../../controller/bottom_nav_controller.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();

    // ============================================================
    // SCREENS
    // ============================================================
    final List<Widget> pages = [
      HomeScreen(),
      CartScreen(),
      FavouriteScreen(),
      ProfileScreen(),
      // const Center(child: Text("Home")),
      // const Center(child: Text("Cart")),
      // const Center(child: Text("Favourite")),
      // const Center(child: Text("Profile")),
    ];

    return Scaffold(
      backgroundColor: AppColor.background,
      extendBody: true,
      // ============================================================
      // BODY
      // ============================================================
      body: Obx(
            () => pages[bottomNavController.currentIndex.value],
      ),

      // ============================================================
      // BOTTOM NAVIGATION BAR (Full Width & Uses drawerGradient1)
      // ============================================================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColor.drawerGradient1, // Background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: Row(
              children: [
                // HOME
                Expanded(
                  child: _BottomNavItem(
                    controller: bottomNavController,
                    index: 0,
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: 'Home',
                  ),
                ),

                // CART
                Expanded(
                  child: _BottomNavItem(
                    controller: bottomNavController,
                    index: 1,
                    icon: Icons.shopping_cart_outlined,
                    selectedIcon: Icons.shopping_cart_rounded,
                    label: 'Cart',
                  ),
                ),

                // FAVOURITE
                Expanded(
                  child: _BottomNavItem(
                    controller: bottomNavController,
                    index: 2,
                    icon: Icons.favorite_border_rounded,
                    selectedIcon: Icons.favorite_rounded,
                    label: 'Favourite',
                  ),
                ),

                // PROFILE
                Expanded(
                  child: _BottomNavItem(
                    controller: bottomNavController,
                    index: 3,
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                    label: 'Profile',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// BOTTOM NAV ITEM
// ==================================================================

class _BottomNavItem extends StatelessWidget {
  final BottomNavController controller;
  final int index;

  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _BottomNavItem({
    required this.controller,
    required this.index,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.currentIndex.value == index;

      // High-contrast colors designed specifically for drawerGradient1 background
      final Color activeColor = AppColor.primary;
      final Color inactiveColor = Colors.white.withOpacity(0.50);

      return GestureDetector(
        onTap: () {
          controller.changeIndex(index);
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primary.withOpacity(0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(
              color: AppColor.primary.withOpacity(0.4),
              width: 1,
            )
                : null,
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isSelected ? 1.05 : 1.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
                const SizedBox(height: 2),
                CustomText(
                  text: label,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}