import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/all_route.dart'; // Ensure AllRoute.updateProfile exists
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColor.text,
      child: SafeArea(
        child: Column(
          children: [
            const Gap(50),
            Center(
              child: Container(
                height: 140.h,
                width: 140.w,
                decoration: BoxDecoration(
                    color: AppColor.drawerGradient1.withOpacity(0.8), // Fixed syntax
                    shape: BoxShape.circle
                ),
                child: const Icon(Icons.person, size: 70, color: Colors.white),
              ),
            ),
            const Gap(40),

            // Navigate to Update Profile Screen
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomButton(
                text: "Edit Profile",
                backgroundColor: AppColor.drawerGradient1,
                onPressed: () {
                  // NAVIGATION USING Get.toNamed
                  Get.toNamed(AllRoute.updateProfile);
                }, textColor: AppColor.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}