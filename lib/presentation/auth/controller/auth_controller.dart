import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/all_route.dart';
import 'package:mye_commerce/core/config/app_url.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_confirm_dialog.dart';
import 'package:mye_commerce/global/custom_snackbar.dart';
import 'package:mye_commerce/local_db/auth_services.dart';

import '../../../core/theme/app_color.dart';
import '../ui/register/widget/register_dialog.dart';

class AuthController extends GetxController {
  // Url
  final url = AppUrl.baseUrl;

  final isLoading = false.obs;
  final isLoading2 = false.obs;

  final registerKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();
  final registerOtpVerifyKey = GlobalKey<FormState>();
  final forgetPasswordSendOtpKey = GlobalKey<FormState>();
  final forgetPasswordVerifyOtpKey = GlobalKey<FormState>();
  final resetNewForgetPasswordKey = GlobalKey<FormState>();

  // Controller
  final loginEmailClt = TextEditingController();
  final loginPasswordClt = TextEditingController();
  final registerEmailClt = TextEditingController();
  final registerPasswordClt = TextEditingController();
  final firstNameClt = TextEditingController();
  final lastNameClt = TextEditingController();
  final registerOtpVerifyClt = TextEditingController();
  final forgetPasswordSendOtpClt = TextEditingController();
  final forgetPasswordVerifyOtpClt = TextEditingController();
  final resetNewForgetPasswordClt = TextEditingController();

  // Separate variable for Login Password
  var isLoginPasswordObscured = true.obs;

  // Separate variable for Register Password
  var isRegisterPasswordObscured = true.obs;

  // Type reset new password
  var isResetNewForgetPasswordObscured = true.obs;

  // Toggle function for Login
  void toggleLoginPasswordVisibility() {
    isLoginPasswordObscured.value = !isLoginPasswordObscured.value;
  }

  // Toggle function for Register
  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordObscured.value = !isRegisterPasswordObscured.value;
  }

  // Reset new password type
  void toggleResetNewForgetPasswordVisibility() {
    isResetNewForgetPasswordObscured.value = !isResetNewForgetPasswordObscured.value;
  }

  // ==========================================
  // 1. REGISTER API
  // ==========================================
  Future<void> registerApi() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(AppUrl.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "first_name": firstNameClt.text.trim(),
          "last_name": lastNameClt.text.trim(),
          "email": registerEmailClt.text.trim(),
          "password": registerPasswordClt.text.trim(),
        }),
      );

      log("Response of register: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar(
          Get.context!,
          title: "Success",
          message: "Account created successfully! Please login.",
        );
        Get.offAllNamed(AllRoute.login);
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        final data = jsonDecode(response.body);
        final detailMsg = data["detail"] ?? "Email already exists.";
        CustomSnackbar(Get.context!, title: "Error", message: detailMsg, isError: true);
      } else {
        CustomSnackbar(Get.context!, title: "Error", message: "Failed to create account.", isError: true);
      }
    } catch (e) {
      log("Error in the register: $e");
      CustomSnackbar(Get.context!, title: "Error", message: "Network connection error.", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 2. LOGIN API
  // ==========================================
  Future<void> loginApi() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(AppUrl.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": loginEmailClt.text.trim(),
          "username": loginEmailClt.text.trim(),
          "password": loginPasswordClt.text.trim(),
        }),
      );

      log("Response of login: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String accessToken = data["access_token"] ?? "";

        // Save Token to Local Storage for authenticated requests
        if (accessToken.isNotEmpty) {
          await AuthServices.setAccessToken(accessToken);
          log("Access Token Saved: $accessToken");
        }

        CustomSnackbar(Get.context!, title: "Success", message: "Logged in successfully!");
        Get.offAllNamed(AllRoute.bottomNav);
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        final data = jsonDecode(response.body);
        final msg = data["detail"] ?? "Incorrect email or password.";
        CustomSnackbar(Get.context!, title: "Error", message: msg, isError: true);
      } else {
        CustomSnackbar(Get.context!, title: "Error", message: "Failed to login ${response.body.toString()}.", isError: true);
      }
    } catch (e) {
      log("Error in the login: $e");
      CustomSnackbar(Get.context!, title: "Error", message: "Network error. Please try again.", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 3. RECOVERY PASSWORD SEND OTP
  // ==========================================
  Future<void> recoveryPasswordSendOtp() async {
    isLoading2.value = true;
    try {
      final response = await http.post(
        Uri.parse(AppUrl.recoveryPassword),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": forgetPasswordSendOtpClt.text.trim(),
        }),
      );

      log("Response of send OTP: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final otp = data["otp"];

        CustomSnackbar(
          Get.context!,
          title: "Success",
          message: otp != null ? "OTP sent! For testing, your code is: $otp" : "OTP has been sent to your email.",
        );
        Get.toNamed(AllRoute.forgetPasswordEnterOtp);
      } else if (response.statusCode == 404) {
        CustomSnackbar(Get.context!, title: "Error", message: "Email address not found.", isError: true);
      } else {
        CustomSnackbar(Get.context!, title: "Error", message: "Failed to send OTP.", isError: true);
      }
    } catch (e) {
      log("Error in the forget password send otp: $e");
    } finally {
      isLoading2.value = false;
    }
  }

  // ==========================================
  // 4. RECOVERY PASSWORD VERIFY OTP
  // ==========================================
  Future<void> recoveryPasswordOtpVerify() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(AppUrl.recoveryOtpVerify),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": forgetPasswordSendOtpClt.text.trim(),
          "otp": forgetPasswordVerifyOtpClt.text.trim(),
        }),
      );

      log("Response of verify OTP: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['recover_password_token'] != null) {
          final String forgetToken = data['recover_password_token'];
          // Save Token to Local Storage
          await AuthServices.setForgetToken(forgetToken);
          log("Forget Token successfully saved: $forgetToken");
        }
        CustomSnackbar(Get.context!, title: "Success", message: "OTP verified successfully!");
        Get.toNamed(AllRoute.enterNewPassword);
      } else if (response.statusCode == 400) {
        CustomSnackbar(Get.context!, title: "Error", message: "Invalid or expired OTP.", isError: true);
      } else {
        CustomSnackbar(Get.context!, title: "Error", message: "Failed to verify OTP.", isError: true);
      }
    } catch (e) {
      log("Error in the forget password verify otp: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 5. RECOVERY NEW PASSWORD
  // ==========================================
  Future<void> recoveryNewPassword() async {
    isLoading.value = true;
    try {
      final String token = AuthServices.getForgetToken() ?? "";

      final response = await http.post(
        Uri.parse(AppUrl.recoveryNewPassword),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "recover_password_token": token,
          "new_password": resetNewForgetPasswordClt.text.trim(),
        }),
      );

      log("Response of reset new password: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          CustomConfirmDialog(
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
            title: "Your password has been reset successfully. Please log in with your new password.",
            child: CustomButton(
              text: "Go to Login",
              backgroundColor: AppColor.drawerGradient1,
              textColor: Colors.white,
              onPressed: () {
                Get.offAllNamed(AllRoute.login);
              },
            ),
          ),
          barrierDismissible: false,
        );
      } else if (response.statusCode == 400) {
        CustomSnackbar(Get.context!, title: "Error", message: "Invalid or expired recovery token.", isError: true);
      } else {
        CustomSnackbar(Get.context!, title: "Error", message: "Failed to reset password.", isError: true);
      }
    } catch (e) {
      log("Error in the reset new forget password: $e");
    } finally {
      isLoading.value = false;
    }
  }
}