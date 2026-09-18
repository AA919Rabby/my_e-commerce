import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/global/custom_text_field.dart';
import '../../../controller/auth_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

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
                        key: authController.forgetPasswordSendOtpKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(70),

                            // Subtitle / Description
                            CustomText(
                              text: "Enter your registered email address to receive an OTP",
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
                                      // Email TextField with Validation
                                      CustomTextField(
                                        controller: authController.forgetPasswordSendOtpClt,
                                        hintText: "Email Address",
                                        keyboardType: TextInputType.emailAddress,
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                          color: AppColor.secondaryText,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          if (!GetUtils.isEmail(value.trim())) {
                                            return 'Invalid email';
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
                                text: authController.isLoading2.value
                                    ? "Sending OTP..."
                                    : "Send OTP",
                                backgroundColor: AppColor.drawerGradient1,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (authController.isLoading2.value) return;
                                  if (authController.forgetPasswordSendOtpKey.currentState!.validate()) {
                                    authController.forgetPasswordSendOtp();
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

          // Bigger Back Button Placed on Top Layer (Receives All Touches)
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(

                      color: Colors.transparent,

                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColor.text,
                      size: 24, // Bigger icon
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