import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../global/custom_text.dart';
import '../../controller/home_controller.dart';
import '../widget/home_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColor.background,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. User Dummy Name
              Obx(
                    () => CustomText(
                  text: homeController.userName.value,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),

              const Gap(4),

              // 2. Location Indicator (Below Name)
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColor.primary,
                  ),
                  const Gap(4),
                  Expanded(
                    child: Obx(
                          () => CustomText(
                        text: homeController.userLocation.value,
                        fontSize: 13,
                        color: AppColor.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(24),

              // 3. Search Bar Widget
              HomeSearchBar(
                controller: homeController.searchController,
                onChanged: (query) {
                  // Handle product search here
                },
              ),

              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}