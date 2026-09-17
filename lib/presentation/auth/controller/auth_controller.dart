import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/config/app_url.dart';
import 'package:mye_commerce/global/custom_snackbar.dart';


class AuthController extends GetxController {

  //Url
  final url=AppUrl.baseUrl;

  final isLoading = false.obs;

  final registerKey=GlobalKey<FormState>();
  final loginKey=GlobalKey<FormState>();


  //Controller
  final loginEmailClt=TextEditingController();
  final loginPasswordClt=TextEditingController();
  final registerEmailClt=TextEditingController();
  final registerPasswordClt=TextEditingController();
  final firstNameClt=TextEditingController();
  final lastNameClt=TextEditingController();

  // Separate variable for Login Password
  var isLoginPasswordObscured = true.obs;

  // Separate variable for Register Password
  var isRegisterPasswordObscured = true.obs;

  // Toggle function for Login
  void toggleLoginPasswordVisibility() {
    isLoginPasswordObscured.value = !isLoginPasswordObscured.value;
  }

  // Toggle function for Register
  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordObscured.value = !isRegisterPasswordObscured.value;
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
         "firstName":firstNameClt.text,
         "lastName":lastNameClt.text,
         "email":registerEmailClt.text,
         "password":registerPasswordClt.text
     })
   );
   log("Response of register: ${response.body}");
   if(response.statusCode==200 || response.statusCode==201){
     CustomSnackbar(Get.context!, title: "Success", message: "Account created successfully, check your email for verification!");
   }else if (response.statusCode==409){
      CustomSnackbar(Get.context!, title: "Error", message: "Email already exists.",isError: true);
   }else{
      CustomSnackbar(Get.context!, title: "Error", message: "Failed to create account.",isError: true);
   }
 }catch(e){
   log("Error in the register: $e");
   CustomSnackbar(Get.context!, title: "Error", message: "Failed to create account.",isError: true);
   CustomSnackbar(Get.context!, title: "Error", message: "Failed to create account: (${e.toString()})",isError: true);
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
        "email":loginEmailClt.text,
        "password":loginPasswordClt.text
      })
    );
    log("Response of login: ${response.body}");
   if(response.statusCode==200){
     CustomSnackbar(Get.context!, title: "Success", message: "Account logged in successfully!");
   }else{
     CustomSnackbar(Get.context!, title: "Error", message: "Failed to login.",isError: true);
   }
  }catch(e){
    log("Error in the login: $e");
    CustomSnackbar(Get.context!, title: "Error", message: "Failed to login.",isError: true);
    CustomSnackbar(Get.context!, title: "Error", message: "Failed to login: (${e.toString()})",isError: true);
    }finally{
      isLoading.value=false;
    }
}




}