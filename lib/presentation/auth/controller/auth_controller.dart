import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
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

  //Url
  final url=AppUrl.baseUrl;

  final isLoading = false.obs;
  final isLoading2 = false.obs;


  final registerKey=GlobalKey<FormState>();
  final loginKey=GlobalKey<FormState>();
  final registerOtpVerifyKey=GlobalKey<FormState>();
  final forgetPasswordSendOtpKey=GlobalKey<FormState>();
  final forgetPasswordVerifyOtpKey=GlobalKey<FormState>();
  final resetNewForgetPasswordKey=GlobalKey<FormState>();


  //Controller
  final loginEmailClt=TextEditingController();
  final loginPasswordClt=TextEditingController();
  final registerEmailClt=TextEditingController();
  final registerPasswordClt=TextEditingController();
  final firstNameClt=TextEditingController();
  final lastNameClt=TextEditingController();
  final registerOtpVerifyClt=TextEditingController();
  final forgetPasswordSendOtpClt=TextEditingController();
  final forgetPasswordVerifyOtpClt=TextEditingController();
  final resetNewForgetPasswordClt=TextEditingController();


  // Separate variable for Login Password
  var isLoginPasswordObscured = true.obs;

  // Separate variable for Register Password
  var isRegisterPasswordObscured = true.obs;
  // Type reet new password
  var isResetNewForgetPasswordObscured = true.obs;

  // Toggle function for Login
  void toggleLoginPasswordVisibility() {
    isLoginPasswordObscured.value = !isLoginPasswordObscured.value;
  }

  // Toggle function for Register
  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordObscured.value = !isRegisterPasswordObscured.value;
  }
  //reset new password type
  void toggleResetNewForgetPasswordVisibility() {
    isResetNewForgetPasswordObscured.value = !isResetNewForgetPasswordObscured.value;
  }


// Add your TextControllers here as well if you haven't already
// final emailController = TextEditingController();
// final passwordController = TextEditingController();
// final firstNameController = TextEditingController();
// final lastNameController = TextEditingController();

Future<void> registerApi()async{
 isLoading.value=true;
 try{
   final response=await http.post(
     Uri.parse(AppUrl.register),
     headers: {
        'Content-Type': 'application/json',
     },
     body: jsonEncode({
         "firstName":firstNameClt.text.trim(),
         "lastName":lastNameClt.text.trim(),
         "email":registerEmailClt.text.trim(),
         "password":registerPasswordClt.text.trim()
     })
   );
   log("Response of register: ${response.body}");
   if(response.statusCode==200 || response.statusCode==201){
     final data=jsonDecode(response.body);
     final otp=data["result"];
   //  CustomSnackbar(Get.context!, title: "Success", message: "Account created successfully!");
     CustomSnackbar(Get.context!, title: "Success", message: "Account created!, OTP is :$otp");
    Get.dialog(const RegisterDialog(), barrierDismissible: false);
   }else if (response.statusCode==409){
      CustomSnackbar(Get.context!, title: "Error", message: "Email already exists.",isError: true);
   }else{
      CustomSnackbar(Get.context!, title: "Error", message: "Failed to create account.",isError: true);
   }
 }catch(e){
   log("Error in the register: $e");
 }
 finally {
   isLoading.value=false;
 }
}
///login api
Future <void> loginApi()async{
  isLoading.value=true;
  try{
    final response=await http.post(
      Uri.parse(AppUrl.login),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email":loginEmailClt.text.trim(),
        "password":loginPasswordClt.text.trim()
      })
    );
    log("Response of login: ${response.body}");
   if(response.statusCode==200){
     //CustomSnackbar(Get.context!, title: "Success", message: "Account logging successfully!");
     Get.offAllNamed(AllRoute.bottomNav);
   }else{
     CustomSnackbar(Get.context!, title: "Error", message: "Failed to login.",isError: true);
   }
  }catch(e){
    log("Error in the login: $e");
    }finally{
      isLoading.value=false;
    }
}
/// register otp verify
Future<void>registerOtpVerify()async{
    isLoading2.value=true;
    try{
      final response=await http.post(
        Uri.parse(AppUrl.registerOtpVerify),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email":registerEmailClt.text.trim(),
          "otp":registerOtpVerifyClt.text.trim()
        }));
          if(response.statusCode==201 || response.statusCode==200){
            Get.back();
            CustomSnackbar(Get.context!, title: "Success", message: "OTP verified successfully!");
          }
          else if(response.statusCode==401){
            CustomSnackbar(Get.context!, title: "Error", message: "Invalid OTP.",isError: true);
          }
          else{
            CustomSnackbar(Get.context!, title: "Error", message: "Failed to verify OTP. ",isError: true);
            log("Failed to verify OTP. ${response.body} ${response.statusCode}");

          }
    }catch(e){
      log("Error in the register otp verify: $e");
    }finally{
      isLoading2.value=false;
    }
}
/// reset password - forget password
  Future<void>forgetPasswordSendOtp()async{
    isLoading2.value=true;
    try{
      final response=await http.post(
        Uri.parse(AppUrl.resetPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email":forgetPasswordSendOtpClt.text.trim()
        }));
          if(response.statusCode==200){
            final data=jsonDecode(response.body);
            final otp=data["result"];
            CustomSnackbar(Get.context!, title: "Success", message: "Your OTP is :$otp");
            Get.toNamed(AllRoute.forgetPasswordEnterOtp);
          }
          else if (response.statusCode==404){
            CustomSnackbar(Get.context!, title: "Error", message: "User not found.",isError: true);
          }
          else{
            CustomSnackbar(Get.context!, title: "Error", message: "Failed to send OTP.",isError: true);
          }
    }catch(e){
      log("Error in the forget password send otp: $e");
    }finally{
      isLoading2.value=false;
    }
}
// reset password otp verify
Future<void>forgetPasswordVerifyOtp()async{
  isLoading.value=true;
  try{
    final response=await http.post(
      Uri.parse(AppUrl.resetPasswordVerifyOtp),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": forgetPasswordSendOtpClt.text.trim(),
        "otp": forgetPasswordVerifyOtpClt.text.trim()
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Drill into the nested result map correctly
      if (data['result'] != null && data['result']['forgetToken'] != null) {
        final String forgetToken = data['result']['forgetToken'];
        // Save to Local Storage
        await AuthServices.setForgetToken(forgetToken);
        log("Forget Token successfully saved: $forgetToken");
      }
      CustomSnackbar(Get.context!, title: "Success", message: "OTP verified successfully!");
      Get.toNamed(AllRoute.enterNewPassword);
    }
    else if (response.statusCode==400){
      CustomSnackbar(Get.context!, title: "Error", message: "Invalid or expired OTP.",isError: true);
    }
    else{
      CustomSnackbar(Get.context!, title: "Error", message: "Failed to verify OTP.",isError: true);
      log("Failed to verify OTP. ${response.body} ${response.statusCode}");
    }
  }catch(e){
      log("Error in the forget password verify otp: $e");
    }
    finally{
      isLoading.value=false;
    }
}
/// make new password
Future<void>resetNewForgetPassword()async{
  isLoading.value=true;
    try{
      final response=await http.patch(
        Uri.parse(AppUrl.resetNewPassword),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "${AuthServices.getForgetToken()}"
        },
        body: jsonEncode({
          "newPassword":resetNewForgetPasswordClt.text.trim()
        }));
          if(response.statusCode==200 || response.statusCode==201){
        // ------
           Get.dialog(
               CustomConfirmDialog(
                   icon: Icons.check_circle_outline,
                   iconColor: Colors.green,
                   title:"Your password has been reset successfully. Please log in with your new password.",
                   child: CustomButton(
                     text: "Go to Login",
                     backgroundColor: AppColor.drawerGradient1,
                     textColor: Colors.white,
                     onPressed: () {
                       Get.offAllNamed(AllRoute.login);
                     },
                   )
               )
           );
      }else {
            CustomSnackbar(Get.context!, title: "Error", message: "Failed to reset password.", isError: true);
          }
    }catch(e){
      log("Error in the reset new forget password: $e");
    }finally{
      isLoading.value=false;
    }
}


}