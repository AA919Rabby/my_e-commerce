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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
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
                    const Gap(10),
                    CustomText(
                      text: "Get connected with us by creating an account",
                      fontSize: 16,
                      color: AppColor.secondaryText,
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
                            prefixIcon: const Icon(Icons.person_outline, color: AppColor.secondaryText),
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
                            prefixIcon: const Icon(Icons.person_outline, color: AppColor.secondaryText),
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
                            prefixIcon: const Icon(Icons.email_outlined, color: AppColor.secondaryText),
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
                              controller: authController.registerPasswordClt,
                              hintText: "Password",
                              obscureText: authController.isRegisterPasswordObscured.value,
                              prefixIcon: const Icon(Icons.lock_outline, color: AppColor.secondaryText),
                              // ADDED SUFFIX ICON TO TOGGLE VISIBILITY
                              suffixIcon: IconButton(
                                icon: Icon(
                                  authController.isRegisterPasswordObscured.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColor.secondaryText,
                                ),
                                onPressed: () {
                                  authController.toggleRegisterPasswordVisibility();
                                },
                              ),
                            );
                          }),
                          const Gap(30),

                        Obx(()=> CustomButton(text: authController.isLoading.value?"Loading...":"Register",
                            backgroundColor: AppColor.drawerGradient1,
                            textColor: Colors.white, onPressed: () {
                           if(authController.isLoading.value) return;
                           if(authController.registerKey.currentState!.validate()){
                             authController.registerApi();
                           }
                            })),
                        ],
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
                            color: AppColor.text,
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
      ),
    );
  }
}