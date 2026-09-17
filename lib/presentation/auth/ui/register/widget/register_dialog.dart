import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/global/custom_text_field.dart';
import '../../../controller/auth_controller.dart';

class RegisterDialog extends StatelessWidget {
  const RegisterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient Glow Top Right
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.drawerGradient1.withOpacity(0.35),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.drawerGradient1.withOpacity(0.3),
                    blurRadius: 80,
                  ),
                ],
              ),
            ),
          ),

          // Ambient Glow Bottom Left
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary.withOpacity(0.35),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.3),
                    blurRadius: 80,
                  ),
                ],
              ),
            ),
          ),

          // Glassmorphic Card
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                child: Form(
                  key: authController.registerOtpVerifyKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge Icon
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.primary.withOpacity(0.15),
                          border: Border.all(
                            color: AppColor.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          size: 30,
                          color: AppColor.primary,
                        ),
                      ),
                      const Gap(16),

                      // Title
                      CustomText(
                        text: "Verify Account",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.text,
                      ),
                      const Gap(8),

                      // Subtitle
                      CustomText(
                        text: "Enter the OTP code sent to\n${authController.registerEmailClt.text.trim()}",
                        fontSize: 14,
                        textAlign: TextAlign.center,
                        color: AppColor.secondaryText,
                      ),
                      const Gap(24),

                      // OTP TextField
                      CustomTextField(
                        controller: authController.registerOtpVerifyClt,
                        hintText: "Enter 4-digit OTP",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }
                          if (value.trim().length < 4) {
                            return "Too short";
                          }
                          return null;
                        },
                        prefixIcon: const Icon(
                          Icons.lock_clock_outlined,
                          color: AppColor.secondaryText,
                        ),
                      ),
                      const Gap(24),

                      // Verify Button
                      Obx(() => CustomButton(
                        text: authController.isLoading.value
                            ? "Verifying..."
                            : "Verify",
                        backgroundColor: AppColor.drawerGradient1,
                        textColor: Colors.white,
                        onPressed: () {
                          if (authController.isLoading.value) return;

                          if (authController.registerOtpVerifyKey.currentState!.validate()) {
                            authController.registerOtpVerify();
                          }
                        },
                      )),
                      const Gap(16),

                      // Cancel
                      GestureDetector(
                        onTap: () {
                          authController.registerOtpVerifyClt.clear();
                          Get.back();
                        },
                        child: CustomText(
                          text: "Cancel",
                          fontSize: 14,
                          color: AppColor.secondaryText,
                        ),
                      ),
                    ],
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