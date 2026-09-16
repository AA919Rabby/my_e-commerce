import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_text.dart';
import '../../../../../global/custom_text_field.dart';
import '../../../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          // Ambient Glow Accent Circles
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.drawerGradient1.withOpacity(0.4),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.drawerGradient1.withOpacity(0.35),
                    blurRadius: 110,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary.withOpacity(0.35),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.3),
                    blurRadius: 110,
                  ),
                ],
              ),
            ),
          ),

          // Main Screen Layer
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Icon Glass Header Badge
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: AppColor.text,
                          ),
                        ),
                      ),
                    ),
                    const Gap(24),
                    CustomText(
                      text: "Welcome Back",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColor.text,
                    ),
                    const Gap(8),
                    CustomText(
                      text: "Login to your account",
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
                                  hintText: "Password",
                                  obscureText: authController
                                      .isLoginPasswordObscured.value,
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: AppColor.secondaryText,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      authController.isLoginPasswordObscured.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColor.secondaryText,
                                    ),
                                    onPressed: () {
                                      authController
                                          .toggleLoginPasswordVisibility();
                                    },
                                  ),
                                );
                              }),
                              const Gap(14),

                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: CustomText(
                                    text: "Forgot Password?",
                                    color: AppColor.secondaryText,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Gap(28),

                              CustomButton(
                                text: "Login",
                                backgroundColor: AppColor.drawerGradient1,
                                textColor: Colors.white,
                                onPressed: () {},
                              ),
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
                          text: "Don't have an account? ",
                          color: AppColor.secondaryText,
                          fontSize: 14,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/register');
                          },
                          child: CustomText(
                            text: "Register",
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}