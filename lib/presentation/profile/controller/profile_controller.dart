import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_url.dart';
import '../../../global/custom_snackbar.dart';
import '../../../local_db/auth_services.dart';
import '../data/profile_model.dart';

class ProfileController extends GetxController {
  // final nameController = TextEditingController();
  // final phoneController = TextEditingController();
  // final addressController = TextEditingController();
  // final photoUrlController = TextEditingController();
  //
  // Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  // RxBool isLoading = false.obs;
  // RxBool isUpdating = false.obs;
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchProfile();
  // }
  //
  // @override
  // void onClose() {
  //   nameController.dispose();
  //   phoneController.dispose();
  //   addressController.dispose();
  //   photoUrlController.dispose();
  //   super.onClose();
  // }
  //
  // // 1. GET USER PROFILE
  // Future<void> fetchProfile() async {
  //   isLoading.value = true;
  //   try {
  //     final token = AuthServices.getAccessToken();
  //
  //     final response = await http.get(
  //       Uri.parse(AppUrl.userProfile),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     log("Fetch Profile Response [${response.statusCode}]: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       profile.value = ProfileModel.fromJson(data);
  //
  //       // Pre-fill controllers
  //       nameController.text = profile.value?.fullName ?? '';
  //       phoneController.text = profile.value?.phoneNumber ?? '';
  //       addressController.text = profile.value?.address ?? '';
  //       photoUrlController.text = profile.value?.profilePictureUrl ?? '';
  //     } else {
  //       log("Failed to load profile: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     log("Error fetching profile: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // // 2. UPDATE USER PROFILE (PUT)
  // Future<void> updateProfile() async {
  //   isUpdating.value = true;
  //   try {
  //     final token = AuthServices.getAccessToken();
  //
  //     final Map<String, dynamic> payload = {
  //       "full_name": nameController.text.trim(),
  //       "phone_number": phoneController.text.trim(),
  //       "address": addressController.text.trim(),
  //       "profile_picture_url": photoUrlController.text.trim(),
  //     };
  //
  //     final response = await http.put(
  //       Uri.parse(AppUrl.userProfile),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode(payload),
  //     );
  //
  //     log("Update Profile Response [${response.statusCode}]: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       profile.value = ProfileModel.fromJson(data);
  //
  //       CustomSnackbar(
  //         Get.context!,
  //         title: "Success",
  //         message: "Profile updated successfully!",
  //       );
  //     } else {
  //       CustomSnackbar(
  //         Get.context!,
  //         title: "Failed",
  //         message: "Could not update profile.",
  //         isError: true,
  //       );
  //     }
  //   } catch (e) {
  //     log("Error updating profile: $e");
  //     CustomSnackbar(
  //       Get.context!,
  //       title: "Error",
  //       message: "Something went wrong.",
  //       isError: true,
  //     );
  //   } finally {
  //     isUpdating.value = false;
  //   }
  // }
}