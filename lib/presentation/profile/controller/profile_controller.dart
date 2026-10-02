import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
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

  RxString base64ImageString = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  RxInt localCompletedCount = 0.obs;

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
    return profile.value?.profilePictureUrl?.trim() ?? '';
  }

  Uint8List? get memoryImageBytes {
    final raw = displayImageUrl;
    if (raw.isEmpty || raw == 'null') return null;
    try {
      if (raw.startsWith('data:image')) {
        final cleanBase64 = raw.split(',').last;
        return base64Decode(cleanBase64);
      }
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  int get totalCompletedServices {
    if (localCompletedCount.value > 0) {
      return localCompletedCount.value;
    }
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

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);

        final bytes = await pickedFile.readAsBytes();
        base64ImageString.value = "data:image/jpeg;base64,${base64Encode(bytes)}";
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

      final safeUrl = AppUrl.userProfile.replaceAll(RegExp(r'/$'), '');

      final response = await http.get(
        Uri.parse(safeUrl),
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
    if (!updateProfileFormKey.currentState!.validate()) {
      return;
    }

    isUpdating.value = true;
    try {
      final token = AuthServices.getAccessToken();

      String finalPhotoUrl = '';
      if (base64ImageString.value.isNotEmpty) {
        finalPhotoUrl = base64ImageString.value;
      } else if (photoUrlController.text.trim().isNotEmpty) {
        finalPhotoUrl = photoUrlController.text.trim();
      } else if (profile.value?.profilePictureUrl != null && profile.value!.profilePictureUrl!.isNotEmpty) {
        finalPhotoUrl = profile.value!.profilePictureUrl!;
      }

      final Map<String, dynamic> payload = {
        "full_name": nameController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "profile_picture_url": finalPhotoUrl,
        "address": addressController.text.trim(),
      };

      final safeUrl = AppUrl.userProfile.replaceAll(RegExp(r'/$'), '');

      final response = await http.put(
        Uri.parse(safeUrl),
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

        profileImage.value = null;
        base64ImageString.value = '';

        CustomSnackbar(
          Get.context!,
          title: "Success",
          message: "Profile updated successfully!",
        );
        Get.back();
        await fetchProfile();
      } else {
        CustomSnackbar(
          Get.context!,
          title: "Failed",
          message: "Could not update profile (${response.statusCode}).",
          isError: true,
        );
      }
    } catch (e) {
      log("Error updating profile: $e");
      CustomSnackbar(
        Get.context!,
        title: "Error",
        message: "Network error. Please try again.",
        isError: true,
      );
    } finally {
      isUpdating.value = false;
    }
  }
}