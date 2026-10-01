import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/presentation/profile/controller/profile_controller.dart';
import 'package:mye_commerce/presentation/cart/controller/cart_controller.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile();

      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().fetchPendingServices();
      } else {
        Get.put(CartController()).fetchPendingServices();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.text,
      appBar: AppBar(
        backgroundColor: AppColor.text,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const CustomText(
          text: "Profile",
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CustomLoader());
          }

          return RefreshIndicator(
            color: AppColor.drawerGradient1,
            onRefresh: () => controller.fetchProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(20),

                  Center(
                    child: Container(
                      height: 110.h,
                      width: 110.w,
                      decoration: BoxDecoration(
                        color: AppColor.drawerGradient1.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.drawerGradient1,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: controller.displayImageUrl.isNotEmpty
                            ? Image.network(
                          controller.displayImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            size: 60.sp,
                            color: AppColor.drawerGradient1,
                          ),
                        )
                            : Icon(
                          Icons.person,
                          size: 60.sp,
                          color: AppColor.drawerGradient1,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),

                  CustomText(
                    text: controller.displayName,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                  const Gap(6),

                  CustomText(
                    text: controller.displayEmail,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.secondaryText,
                  ),
                  const Gap(8),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColor.drawerGradient1.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: CustomText(
                      text: controller.memberSinceFormatted,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.drawerGradient1,
                    ),
                  ),

                  const Gap(30),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 24,
                              ),
                            ),
                            const Gap(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                CustomText(
                                  text: "Total Completed Services",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black,
                                ),
                                Gap(2),
                                CustomText(
                                  text: "Successfully finished",
                                  fontSize: 12,
                                  color: AppColor.secondaryText,
                                ),
                              ],
                            ),
                          ],
                        ),
                        CustomText(
                          text: "${controller.totalCompletedServices}",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),

                  const Gap(40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}