import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/global/custom_text_field.dart';
import '../../../controller/auth_controller.dart';

class EnterOtpScreen extends StatelessWidget {
  const EnterOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          // Ambient Glow Background Circle Top-Left
          Positioned(
            top: -80,
            left: -40,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.drawerGradient1.withOpacity(0.35),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.drawerGradient1.withOpacity(0.3),
                    blurRadius: 110,
                  ),
                ],
              ),
            ),
          ),

          // Ambient Glow Background Circle Bottom-Right
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary.withOpacity(0.4),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.3),
                    blurRadius: 110,
                  ),
                ],
              ),
            ),
          ),

          // Main Form Content with working Spacer
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: authController.forgetPasswordVerifyOtpKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(70),

                            // Subtitle / Description
                            CustomText(
                              text: "Enter the OTP code sent to\n${authController.forgetPasswordSendOtpClt.text.trim()}",
                              fontSize: 15,
                              textAlign: TextAlign.center,
                              color: AppColor.secondaryText,
                            ),
                            const Gap(36),

                            // Glassmorphic Card Container
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                child: Container(
                                  padding: const EdgeInsets.all(26),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.14),
                                        Colors.white.withOpacity(0.04),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.18),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // OTP TextField with Validation
                                      CustomTextField(
                                        controller: authController.forgetPasswordVerifyOtpClt,
                                        hintText: "Enter 4-digit OTP",
                                        keyboardType: TextInputType.number,
                                        prefixIcon: const Icon(
                                          Icons.lock_clock_outlined,
                                          color: AppColor.secondaryText,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          if (value.trim().length < 4) {
                                            return 'Too short';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Spacer pushes the button to the bottom
                            const Spacer(),

                            // Bottom Button
                            Obx(
                                  () => CustomButton(
                                text: authController.isLoading.value
                                    ? "Verifying OTP..."
                                    : "Verify OTP",
                                backgroundColor: AppColor.drawerGradient1,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (authController.isLoading.value) return;
                                  if (authController.forgetPasswordVerifyOtpKey.currentState!.validate()) {
                                    authController.forgetPasswordVerifyOtp();
                                  }
                                },
                              ),
                            ),
                            const Gap(24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bigger Back Button Placed on Top Layer
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 52.w,
                    height: 52.h,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColor.text,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}