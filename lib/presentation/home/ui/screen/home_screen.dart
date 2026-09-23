import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/presentation/home/ui/widget/home_categories.dart';
import 'package:mye_commerce/presentation/home/ui/widget/home_product.dart';
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
      color: AppColor.text, // RESTORED TO LIGHT BACKGROUND
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            await homeController.onRefreshHome();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                    color: AppColor.black, // RESTORED TO BLACK TEXT
                  ),
                ),

                const Gap(4),

                // 2. Location Indicator
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
                    homeController.onSearchChanged(query);
                  },
                ),

                const Gap(10),
                const CustomText(text: "Categories", fontSize: 16, color: AppColor.black),
                const Gap(10),

                const SizedBox(
                  width: double.infinity,
                  child: HomeCategories(),
                ),

                const Gap(10),
                const CustomText(text: "Today's deal", fontSize: 16, color: AppColor.black),
                const Gap(10),

                const HomeProduct(),
                const Gap(30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}