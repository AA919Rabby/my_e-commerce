import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../core/config/app_url.dart';
import '../../../global/custom_snackbar.dart';
import '../../../local_db/auth_services.dart';
import '../data/profile_model.dart';

class ProfileController extends GetxController {
  static ProfileController get to {
    if (Get.isRegistered<ProfileController>()) {
      return Get.find<ProfileController>();
    } else {
      return Get.put(ProfileController(), permanent: true);
    }
  }

  final updateProfileFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final photoUrlController = TextEditingController();

  Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  Rx<File?> profileImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    photoUrlController.dispose();
    super.onClose();
  }

  // ==========================================
  // GETTERS FOR THE UI (NO LOGIC IN UI SCREEN)
  // ==========================================

  String get displayName {
    final name = profile.value?.fullName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = profile.value?.email?.trim();
    if (email != null && email.isNotEmpty) return email.split('@').first;
    return "User Name";
  }

  String get displayEmail {
    final email = profile.value?.email?.trim();
    if (email != null && email.isNotEmpty) return email;
    return "No email registered";
  }

  String get displayImageUrl {
    return profile.value?.profilePictureUrl ?? '';
  }

  int get totalCompletedServices {
    return profile.value?.totalCompletedServices ?? 0;
  }

  String get memberSinceFormatted {
    final rawDate = profile.value?.createdAt;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    if (rawDate == null || rawDate.isEmpty || rawDate == 'null') {
      final now = DateTime.now();
      return "Member since ${months[now.month - 1]} ${now.year}";
    }
    try {
      final date = DateTime.parse(rawDate);
      return "Member since ${months[date.month - 1]} ${date.year}";
    } catch (_) {
      return "Member since $rawDate";
    }
  }

  // ==========================================
  // API CALLS
  // ==========================================

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final token = AuthServices.getAccessToken();
      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(AppUrl.userProfile),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log("Fetch Profile Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        profile.value = ProfileModel.fromJson(data);

        nameController.text = profile.value?.fullName ?? '';
        phoneController.text = profile.value?.phoneNumber ?? '';
        addressController.text = profile.value?.address ?? '';
        photoUrlController.text = profile.value?.profilePictureUrl ?? '';
      } else {
        log("Failed to load profile: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (profileImage.value == null) {
      CustomSnackbar(
        Get.context!,
        title: "Error",
        message: "Select a profile image.",
        isError: true, // Assuming this triggers a warning/error style
      );
      return;
    }
    if (!updateProfileFormKey.currentState!.validate()) {
      return;
    }

    isUpdating.value = true;
    try {
      final token = AuthServices.getAccessToken();

      final String? photoUrl = profileImage.value != null
          ? profileImage.value!.path
          : (photoUrlController.text.trim().isNotEmpty
          ? photoUrlController.text.trim()
          : null);

      final Map<String, dynamic> payload = {
        "full_name": nameController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "profile_picture_url": photoUrl,
        "address": addressController.text.trim(),
      };

      // Strip trailing slash cleanly
      final url = Uri.parse(AppUrl.userProfile.replaceAll(RegExp(r'/$'), ''));

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      log("Update Profile Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        profile.value = ProfileModel.fromJson(data);

        CustomSnackbar(
          Get.context!,
          title: "Success",
          message: "Profile updated successfully!",
        );
        Get.back();
      } else {
        // ONLY SHOW FAILURE IF STATUS CODE IS NOT 200/201
        CustomSnackbar(
          Get.context!,
          title: "Failed",
          message: "Could not update profile (${response.statusCode}).",
          isError: true,
        );
      }
    } catch (e) {
      log("Error updating profile: $e");
      // If error happens, check if profile was actually updated in the background
      await fetchProfile();
      if (profile.value?.fullName == nameController.text.trim()) {
        Get.back();
      } else {
        CustomSnackbar(
          Get.context!,
          title: "Error",
          message: "Network error. Please try again.",
          isError: true,
        );
      }
    } finally {
      isUpdating.value = false;
    }
  }


}