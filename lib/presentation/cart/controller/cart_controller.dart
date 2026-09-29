import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mye_commerce/presentation/cart/ui/widget/payment_web_view.dart';
import '../../../core/config/app_url.dart';
import '../../../global/custom_snackbar.dart';
import '../../../local_db/auth_services.dart';
import '../data/pending_service_model.dart';


class CartController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final postcodeController = TextEditingController();
  final phoneController = TextEditingController();

  RxList<PendingService> pendingServicesList = <PendingService>[].obs;
  RxList<PendingService> cancelServicesList = <PendingService>[].obs;

  RxBool isLoading = false.obs;
  RxBool isFetchingPending = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingServices();
  }

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
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final token = AuthServices.getAccessToken();
      String fullAddress = "${nameController.text.trim()}, ${addressController.text.trim()}, ${postcodeController.text.trim()},${ageController.text.trim()}";

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
        Get.back();
        fetchPendingServices();
      } else {
        CustomSnackbar(Get.context!, title: "Failed", message: "Services failed.", isError: true);
      }
    } catch (e) {
      CustomSnackbar(Get.context!, title: "Error", message: "Something went wrong.", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPendingServices() async {
    isFetchingPending.value = true;
    try {
      final token = AuthServices.getAccessToken();

      final response = await http.get(
        Uri.parse(AppUrl.pendingServices),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);

        var allItems = jsonResponse.map((data) => PendingService.fromJson(data)).toList();

        pendingServicesList.assignAll(allItems.where((item) => item.status == 'PENDING'));

        cancelServicesList.assignAll(allItems.where((item) =>
        item.status?.toUpperCase() == 'CANCELLED' ||
            item.status?.toUpperCase() == 'CANCEL' ||
            item.status?.toUpperCase() == 'CANCELED'));

      } else {
        print("Failed to fetch pending services: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching pending services: $e");
    } finally {
      isFetchingPending.value = false;
    }
  }

  Future<void> cancelServiceOrder(String orderId) async {
    try {
      pendingServicesList.removeWhere((item) => item.id.toString() == orderId);

      final token = AuthServices.getAccessToken();

      final response = await http.post(
        Uri.parse(AppUrl.cancelServices(orderId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        CustomSnackbar(Get.context!, title: "Success", message: "Order cancelled successfully.");
        fetchPendingServices();
      } else {
        fetchPendingServices();
        CustomSnackbar(Get.context!, title: "Failed", message: "Could not cancel order.", isError: true);
      }
    } catch (e) {
      fetchPendingServices();
      CustomSnackbar(Get.context!, title: "Error", message: "Something went wrong.", isError: true);
    }
  }

  // --- NEW: Initiate SSLCommerz Payment ---
  Future<void> initiatePayment(String orderId) async {
    isLoading.value = true;
    try {
      final token = AuthServices.getAccessToken();

      final response = await http.post(
        Uri.parse(AppUrl.makePayment),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'order_id': orderId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Note: Change 'url' below if your API returns the link under a different key (like 'GatewayPageURL' or 'payment_url')
        String? paymentUrl = data['url'] ?? data['GatewayPageURL'];

        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          // Open the In-App WebView
          final result = await Get.to(() => PaymentWebView(url: paymentUrl));

          if (result == 'success') {
            CustomSnackbar(Get.context!, title: "Success", message: "Payment completed successfully!");
            fetchPendingServices(); // Refresh list to move it to complete
          } else if (result == 'fail') {
            CustomSnackbar(Get.context!, title: "Failed", message: "Payment was cancelled or failed.", isError: true);
          }
        } else {
          CustomSnackbar(Get.context!, title: "Error", message: "Could not retrieve payment URL from server.", isError: true);
        }
      } else {
        CustomSnackbar(Get.context!, title: "Failed", message: "Could not initiate payment.", isError: true);
      }
    } catch (e) {
      CustomSnackbar(Get.context!, title: "Error", message: "Something went wrong with the payment.", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}