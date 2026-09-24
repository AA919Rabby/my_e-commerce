import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mye_commerce/core/config/app_url.dart'; // Make sure this exists
import 'package:mye_commerce/local_db/auth_services.dart';
import 'package:mye_commerce/global/custom_snackbar.dart'; // Assuming you have this
// Import the model you just created

import '../data/update_profile_model.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  // Image handling
  var profileImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  // Text Controller for the field in Postman ("proffesion")
  TextEditingController professionController = TextEditingController();

  /// Function to pick image
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  /// Function to Update Profile (Matches your Postman setup)
  Future<void> updateProfile() async {
    // Basic validation
    if (professionController.text.isEmpty && profileImage.value == null) {
      Get.snackbar("Error", "Please change something to update");
      return;
    }

    isLoading.value = true;

    try {
      // Get the token from your AuthServices
      String? token = AuthServices.getAccessToken();

      // We use MultipartRequest for sending form-data (Files + Text)
      var request = http.MultipartRequest('PUT', Uri.parse(AppUrl.updateProfile)); // Ensure AppUrl.updateProfile is defined

      // 1. Add Headers
      request.headers.addAll({
        'Authorization': '$token', // Add token just like Postman
        'Accept': 'application/json',
      });

      // 2. Add bodyData (Postman shows it as a JSON string inside a text field)
      Map<String, String> bodyMap = {
        "proffesion": professionController.text // Spelled exactly like your Postman screenshot
      };
      request.fields['bodyData'] = jsonEncode(bodyMap);

      // 3. Add Profile Image (if selected)
      if (profileImage.value != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'profileImage',
          profileImage.value!.path,
        );
        request.files.add(multipartFile);
      }

      log("Sending Update Profile Request to: ${request.url}");

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log("Update Profile API Status Code: ${response.statusCode}");
      log("Update Profile API Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final UpdateProfileModel result = UpdateProfileModel.fromJson(jsonData);

        Get.snackbar("Success", result.message ?? "Profile Updated Successfully",
            backgroundColor: Colors.green, colorText: Colors.white);

        Get.back(); // Go back to profile screen on success
      } else {
        Get.snackbar("Error", "Failed to update profile",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      log("Update Profile catch error: $e");
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}