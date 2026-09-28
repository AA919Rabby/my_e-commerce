import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_url.dart';
import '../../../global/custom_snackbar.dart';
import '../../../local_db/auth_services.dart';


class CartController extends GetxController {
  // Form Key for validation
  final formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final postcodeController = TextEditingController();
  final phoneController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    postcodeController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> submitServiceOrder(String productId) async {
    // Check if all fields pass the validation rules
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // Get the token from your local storage/AuthServices
      final token = AuthServices.getAccessToken();

      // Formatting the address and postcode together for the API
      String fullAddress = "${nameController.text.trim()}, ${addressController.text.trim()}, ${postcodeController.text.trim()},${ageController.text.trim()}";

      // Payload strictly containing the 3 requested fields
      final Map<String, dynamic> payload = {
        "service_id": productId,
        "service_address": fullAddress,
        "customer_phone": phoneController.text.trim(),
      };

      final response = await http.post(
        Uri.parse(AppUrl.makeServices),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar(Get.context!, title: "Success", message: "Services confirm.");
        Get.back(); // Return to the previous screen on success
      } else {
        CustomSnackbar(Get.context!, title: "Failed", message: "Services failed.", isError: true);
      }
    } catch (e) {
      CustomSnackbar(Get.context!, title: "Error", message: "Something went wrong.", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}