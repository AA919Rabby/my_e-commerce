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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.drawerGradient1,
              AppColor.drawerGradient2,
              AppColor.drawerGradient3,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColor.text),
                  const Gap(20),
                  CustomText(
                    text: "Welcome Back",
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColor.text,
                  ),
                  const Gap(10),
                  CustomText(
                    text: "Login to your account",
                    fontSize: 16,
                    color: AppColor.text,
                  ),
                  const Gap(40),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: "Email Address",
                          // controller: authController.emailController,
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColor.secondaryText),
                        ),
                        const Gap(20),

                        // WRAPPED IN Obx() FOR LIVE UPDATES
                        Obx(() {
                          return CustomTextField(
                            hintText: "Password",
                            // controller: authController.passwordController,
                            obscureText: authController.isLoginPasswordObscured.value,
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColor.secondaryText),
                            // ADDED SUFFIX ICON TO TOGGLE VISIBILITY
                            suffixIcon: IconButton(
                              icon: Icon(
                                authController.isLoginPasswordObscured.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.secondaryText,
                              ),
                              onPressed: () {
                                authController.toggleLoginPasswordVisibility();
                              },
                            ),
                          );
                        }),
                        const Gap(10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: CustomText(
                              text: "Forgot Password?",
                              color: AppColor.text,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Gap(30),

                       CustomButton(text: "Login", backgroundColor: AppColor.drawerGradient1, textColor: Colors.white, onPressed: () {})
                      ],
                    ),
                  ),
                  const Gap(30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Don't have an account? ",
                        color: AppColor.text,
                        fontSize: 14,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/register');
                        },
                        child: CustomText(
                          text: "Register",
                          color: AppColor.text,
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
      ),
    );
  }
}