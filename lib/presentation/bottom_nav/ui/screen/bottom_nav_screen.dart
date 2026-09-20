import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // ADD YOUR REAL SCREENS HERE LATER
    // ============================================================

    final List<Widget> pages = [
      const  Center(child: Text("Home"),),// HomePage()
      const Center(child: Text("Cart"),), // CartPage()
      const Center(child: Text("Favourite"),), // FavouritePage()
      const Center(child: Text("Profile"),), // ProfilePage()
    ];

    return Scaffold(
      backgroundColor: AppColor.background,

      // ============================================================
      // BODY
      // ============================================================

      body: Obx(
            () => pages[bottomNavController.currentIndex.value],
      ),

      // ============================================================
      // BOTTOM NAVIGATION BAR
      // ============================================================

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 82,

          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 12,
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),

          decoration: BoxDecoration(
            color: AppColor.drawerGradient1,

            borderRadius: BorderRadius.circular(28),

            boxShadow: [
              BoxShadow(
                color: AppColor.drawerGradient1.withOpacity(0.35),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Obx(
                () => Row(
              children: [
                // ==================================================
                // HOME
                // ==================================================

                Expanded(
                  child: _BottomNavItem(
                    controller: bottomNavController,
                    index: 0,
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: 'Home',
                  ),
                ),

                // ==================================================
                // CART
                // ==================================================

                Expanded(
                  child: _BottomNavItem(
                    controller: bottomNavController,
                    index: 1,
                    icon: Icons.shopping_cart_outlined,
                    selectedIcon: Icons.shopping_cart_rounded,
                    label: 'Cart',
                  ),
                ),

                // ==================================================
                // FAVOURITE
                // ==================================================

                Expanded(
                  child: _BottomNavItem(
                    controller: bottomNavController,
                    index: 2,
                    icon: Icons.favorite_border_rounded,
                    selectedIcon: Icons.favorite_rounded,
                    label: 'Favourite',
                  ),
                ),

                // ==================================================
                // PROFILE
                // ==================================================

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
    final bool isSelected =
        controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        curve: Curves.easeOutCubic,

        margin: const EdgeInsets.symmetric(
          horizontal: 4,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 7,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.selectedBackground
              : Colors.transparent,

          borderRadius: BorderRadius.circular(21),

          // FLASH / GLOW EFFECT
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColor.primary.withOpacity(0.70),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: AppColor.secondary.withOpacity(0.45),
              blurRadius: 10,
            ),
          ]
              : [],
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
                  size: 25,
                  color: isSelected
                      ? AppColor.text
                      : AppColor.background,
                ),
              ),

              const SizedBox(height: 3),

              CustomText(
                text: label,
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: isSelected
                    ? AppColor.text
                    : AppColor.background,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}