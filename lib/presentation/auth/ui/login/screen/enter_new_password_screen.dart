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

class EnterNewPasswordScreen extends StatelessWidget {
  const EnterNewPasswordScreen({super.key});

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
                        key: authController.resetNewForgetPasswordKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(70),

                            // Subtitle / Description
                            CustomText(
                              text: "Enter your new password to secure your account",
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
                                      // New Password TextField with Validation
                                      Obx(() {
                                        return CustomTextField(
                                          controller: authController.resetNewForgetPasswordClt,
                                          hintText: "New Password",
                                          obscureText: authController.isResetNewForgetPasswordObscured.value,
                                          prefixIcon: const Icon(
                                            Icons.lock_outline,
                                            color: AppColor.secondaryText,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              authController.isResetNewForgetPasswordObscured.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: AppColor.secondaryText,
                                            ),
                                            onPressed: () {
                                              authController.toggleResetNewForgetPasswordVisibility();
                                            },
                                          ),
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Required';
                                            }
                                            if (value.trim().length < 6) {
                                              return 'Too short';
                                            }
                                            return null;
                                          },
                                        );
                                      }),
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
                                    ? "Resetting..."
                                    : "Reset Password",
                                backgroundColor: AppColor.drawerGradient1,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (authController.isLoading.value) return;
                                  if (authController.resetNewForgetPasswordKey.currentState!.validate()) {
                                    authController.resetNewForgetPassword();
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