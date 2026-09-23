import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';
import '../../controller/home_controller.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const HomeSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // RESTORED TO BRIGHT WHITE
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.drawerGradient1.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: (val) {
          homeController.onSearchChanged(val);
          if (onChanged != null) {
            onChanged!(val);
          }
        },
        style: const TextStyle(color: AppColor.black), // RESTORED TO BLACK TEXT
        cursorColor: AppColor.primary,
        decoration: InputDecoration(
          hintText: "Search products...",
          hintStyle: TextStyle(
            color: AppColor.secondaryText.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Obx(() {
            final bool isTyped = homeController.searchQuery.value.isNotEmpty;

            if (isTyped) {
              return GestureDetector(
                onTap: () {
                  homeController.clearSearch();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 22,
                ),
              );
            }

            return const Icon(
              Icons.search,
              color: AppColor.secondaryText,
              size: 22,
            );
          }),
          suffixIcon: Obx(
                () => GestureDetector(
              onTap: () {
                homeController.toggleListening();
              },
              child: Icon(
                homeController.isListening.value ? Icons.mic : Icons.mic_none,
                color: homeController.isListening.value
                    ? Colors.redAccent
                    : AppColor.secondaryText,
                size: 22,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}