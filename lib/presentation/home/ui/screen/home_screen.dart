import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/all_route.dart';
import 'package:mye_commerce/presentation/home/ui/widget/home_categories.dart';
import 'package:mye_commerce/presentation/home/ui/widget/home_product.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../global/custom_text.dart';
import '../../../notificatioon/controller/notification_controller.dart';
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
      // Using AppColor.text (#F3F5FA) provides a beautiful light-mode background
      color: AppColor.text,
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator.adaptive(
          color: AppColor.drawerGradient1,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await homeController.onRefreshHome();
            // Optional: Also refresh notifications when pulling down
            NotificationController.to.fetchNotifications();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================================
                // 1. TOP HEADER (GREETING & NOTIFICATION)
                // ==========================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Welcome chief,",
                          fontSize: 14,
                          color: AppColor.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        const Gap(4),
                        Obx(
                              () => CustomText(
                            text: homeController.userName.value,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),

                    // Notification / Profile Icon Mockup
                    Obx(() {
                      final count = NotificationController.to.unreadCount;

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(AllRoute.notification);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.black87,
                                size: 24,
                              ),
                            ),
                            if (count > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      count > 9 ? '9+' : '$count',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    })
                  ],
                ),

                const Gap(10),

                // ==========================================================
                // 2. LOCATION PILL
                // ==========================================================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColor.drawerGradient1.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColor.drawerGradient1,
                      ),
                      const Gap(6),
                      Flexible(
                        child: Obx(
                              () => CustomText(
                            text: homeController.userLocation.value,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(14),

                // ==========================================================
                // 3. SEARCH BAR
                // ==========================================================
                HomeSearchBar(
                  controller: homeController.searchController,
                  onChanged: (query) {
                    homeController.onSearchChanged(query);
                  },
                ),

                const Gap(13),

                // ==========================================================
                // 4. CATEGORIES SECTION
                // ==========================================================
                const CustomText(
                  text: "Categories",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
                const Gap(10),

                const SizedBox(
                  width: double.infinity,
                  child: HomeCategories(),
                ),

                const Gap(15),

                // ==========================================================
                // 5. TODAY'S DEAL SECTION
                // ==========================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Today's deal",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                    InkWell(
                      onTap: (){
                        Get.toNamed(AllRoute.viewAll);
                      },
                      child: CustomText(
                        text: "View all",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.drawerGradient1,
                      ),
                    ),
                  ],
                ),

                const Gap(10),

                const HomeProduct(),

                const Gap(30), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}