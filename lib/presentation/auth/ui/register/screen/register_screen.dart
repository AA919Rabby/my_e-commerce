import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_text.dart';
import '../../../../../global/custom_text_field.dart';
import '../../../controller/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          // Ambient Glow Background Circles
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

          // Main Form Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: authController.registerKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(20),
                      CustomText(
                        text: "Create Account",
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColor.text,
                      ),
                      const Gap(8),
                      CustomText(
                        text: "Get connected with us by creating an account",
                        fontSize: 16,
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
                                CustomTextField(
                                  controller: authController.firstNameClt,
                                  hintText: "First Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (value.length < 3) {
                                      return 'Too short';
                                    }
                                    return null;
                                  },
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: AppColor.secondaryText,
                                  ),
                                ),
                                const Gap(20),

                                CustomTextField(
                                  controller: authController.lastNameClt,
                                  hintText: "Last Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (value.length < 3) {
                                      return 'Too short';
                                    }
                                    return null;
                                  },
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: AppColor.secondaryText,
                                  ),
                                ),
                                const Gap(20),

                                CustomTextField(
                                  controller: authController.registerEmailClt,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (!GetUtils.isEmail(value)) {
                                      return 'Invalid email';
                                    }
                                    return null;
                                  },
                                  hintText: "Email Address",
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: AppColor.secondaryText,
                                  ),
                                ),
                                const Gap(20),

                                // WRAPPED IN Obx() FOR LIVE UPDATES
                                Obx(() {
                                  return CustomTextField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (value.length < 6) {
                                        return 'Too short';
                                      }
                                      return null;
                                    },
                                    controller:
                                    authController.registerPasswordClt,
                                    hintText: "Password",
                                    obscureText: authController
                                        .isRegisterPasswordObscured.value,
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: AppColor.secondaryText,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        authController
                                            .isRegisterPasswordObscured
                                            .value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColor.secondaryText,
                                      ),
                                      onPressed: () {
                                        authController
                                            .toggleRegisterPasswordVisibility();
                                      },
                                    ),
                                  );
                                }),
                                const Gap(28),

                                Obx(() => CustomButton(
                                  text: authController.isLoading.value
                                      ? "Loading..."
                                      : "Register",
                                  backgroundColor: AppColor.drawerGradient1,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (authController.isLoading.value) {
                                      return;
                                    }
                                    if (authController
                                        .registerKey.currentState!
                                        .validate()) {
                                      authController.registerApi();
                                    }
                                  },
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Gap(30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Already have an account? ",
                            color: AppColor.secondaryText,
                            fontSize: 14,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: CustomText(
                              text: "Login",
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
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