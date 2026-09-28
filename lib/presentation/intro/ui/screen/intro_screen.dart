import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';

import '../../controller/intro_controller.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is initialized, keeping your original logic intact
    final controller = Get.find<IntroController>();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          // =========================================================
          // 1. Ambient Glow Background Shapes (Positioning Fixed)
          // =========================================================
          Positioned(
            top: -size.height * 0.05,
            left: -size.width * 0.2,
            child: Container(
              width: 350.w,
              height: 350.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.drawerGradient1.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.drawerGradient1.withOpacity(0.3),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.05,
            right: -size.width * 0.2,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.3),
                    blurRadius: 150,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          // =========================================================
          // 2. Main Content Layer
          // =========================================================
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),

                  // =========================================================
                  // 3. True Glassmorphic Logo Card
                  // =========================================================
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 35.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(32.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 30,
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Premium Brand Icon
                              Container(
                                padding: EdgeInsets.all(16.sp),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.drawerGradient1.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.home_repair_service_rounded,
                                  color: AppColor.drawerGradient1,
                                  size: 45.sp,
                                ),
                              ),

                              const Gap(16),

                              // Main Title
                              CustomText(
                                text: "TN Service",
                                color: AppColor.text,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                letterSpacing: 1.2,
                              ),

                              const Gap(6),

                              // Professional Tagline
                              CustomText(
                                text: "Your Trusted Service Partner",
                                color: AppColor.secondaryText,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // =========================================================
                  // 4. Loading Indicator
                  // =========================================================
                  const CustomLoader(),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}