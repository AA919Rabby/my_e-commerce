import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mye_commerce/presentation/cart/ui/widget/payment_web_view.dart';
import '../../../all_route.dart';
import '../../../core/config/app_url.dart';
import '../../../global/custom_snackbar.dart';
import '../../../global/custom_button.dart';
import '../../../local_db/auth_services.dart';
import '../data/pending_service_model.dart';
import '../../../core/theme/app_color.dart';
import '../../home/data/review_model.dart';

class CartController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final postcodeController = TextEditingController();
  final phoneController = TextEditingController();

  RxList<PendingService> pendingServicesList = <PendingService>[].obs;
  RxList<PendingService> cancelServicesList = <PendingService>[].obs;
  RxList<PendingService> completedServicesList = <PendingService>[].obs;

  // Observable list of reviews parsed using ReviewModel
  RxList<ReviewModel> serviceReviewsList = <ReviewModel>[].obs;
  RxBool isFetchingReviews = false.obs;

  RxBool isLoading = false.obs;
  RxBool isFetchingPending = false.obs;
  RxBool isSubmittingReview = false.obs;

  RxString payingOrderId = ''.obs;

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
      String fullAddress =
          "${nameController.text.trim()}, ${addressController.text.trim()}, ${postcodeController.text.trim()}, ${ageController.text.trim()}";

      final int? parsedServiceId = int.tryParse(productId);

      final Map<String, dynamic> payload = {
        "service_id": parsedServiceId ?? productId,
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
        CustomSnackbar(
          Get.context!,
          title: "Success",
          message: "Services confirm.",
        );
        Get.back();
        nameController.clear();
        ageController.clear();
        addressController.clear();
        postcodeController.clear();
        phoneController.clear();

        fetchPendingServices();
      } else {
        CustomSnackbar(
          Get.context!,
          title: "Failed",
          message: "Services failed.",
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar(
        Get.context!,
        title: "Error",
        message: "Something went wrong.",
        isError: true,
      );
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

        var allItems = jsonResponse
            .map((data) => PendingService.fromJson(data))
            .toList();

        pendingServicesList.assignAll(
          allItems.where(
                (item) => item.status?.toUpperCase() == 'PENDING',
          ),
        );

        cancelServicesList.assignAll(
          allItems.where(
                (item) =>
            item.status?.toUpperCase() == 'CANCELLED' ||
                item.status?.toUpperCase() == 'CANCEL' ||
                item.status?.toUpperCase() == 'CANCELED',
          ),
        );

        completedServicesList.assignAll(
          allItems.where(
                (item) =>
            item.status?.toUpperCase() == 'COMPLETED' ||
                item.status?.toUpperCase() == 'COMPLETE' ||
                item.status?.toUpperCase() == 'PAID' ||
                item.status?.toUpperCase() == 'PROCESSING' ||
                item.status?.toUpperCase() == 'CONFIRMED' ||
                item.status?.toUpperCase() == 'SUCCESS',
          ),
        );
      } else {
        log("Failed to fetch pending services: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching pending services: $e");
    } finally {
      isFetchingPending.value = false;
    }
  }

  Future<void> completeServiceOrder(String orderId) async {
    try {
      final token = AuthServices.getAccessToken();

      final response = await http.post(
        Uri.parse(AppUrl.completeServices(orderId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar(
          Get.context!,
          title: "Success",
          message: "Order completed successfully.",
        );
        fetchPendingServices();
      } else {
        CustomSnackbar(
          Get.context!,
          title: "Failed",
          message: "Could not complete order.",
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar(
        Get.context!,
        title: "Error",
        message: "Something went wrong.",
        isError: true,
      );
    }
  }

  Future<void> cancelServiceOrder(String orderId) async {
    try {
      pendingServicesList.removeWhere(
            (item) => item.id.toString() == orderId,
      );

      final token = AuthServices.getAccessToken();

      final response = await http.post(
        Uri.parse(AppUrl.cancelServices(orderId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        CustomSnackbar(
          Get.context!,
          title: "Success",
          message: "Order cancelled successfully.",
        );
        fetchPendingServices();
      } else {
        fetchPendingServices();
        CustomSnackbar(
          Get.context!,
          title: "Failed",
          message: "Could not cancel order.",
          isError: true,
        );
      }
    } catch (e) {
      fetchPendingServices();
      CustomSnackbar(
        Get.context!,
        title: "Error",
        message: "Something went wrong.",
        isError: true,
      );
    }
  }

  Future<void> initiatePayment(String orderId) async {
    payingOrderId.value = orderId;
    try {
      final token = AuthServices.getAccessToken();
      final dynamic parsedOrderId = int.tryParse(orderId) ?? orderId;

      final response = await http.post(
        Uri.parse(AppUrl.makePayment),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'order_id': parsedOrderId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        String? paymentUrl = data['url'] ??
            data['GatewayPageURL'] ??
            data['payment_session_url'] ??
            data['payment_url'];

        if (paymentUrl == null && data['data'] != null && data['data'] is Map) {
          paymentUrl = data['data']['url'] ??
              data['data']['GatewayPageURL'] ??
              data['data']['payment_session_url'] ??
              data['data']['payment_url'];
        }

        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          final result = await Get.toNamed(
            AllRoute.paymentWebView,
            arguments: paymentUrl,
          );

          if (result == 'success') {
            CustomSnackbar(
              Get.context!,
              title: "Success",
              message: "Payment completed successfully!",
            );
            fetchPendingServices();
          } else if (result == 'fail') {
            CustomSnackbar(
              Get.context!,
              title: "Failed",
              message: "Payment was cancelled or failed. ${response.body}",
              isError: true,
            );
          }
        }
      }
    } catch (e) {
      CustomSnackbar(
        Get.context!,
        title: "Error",
        message: "Something went wrong with the payment.",
        isError: true,
      );
    } finally {
      payingOrderId.value = '';
    }
  }

  // ==========================================================
  // GET REVIEWS USING REVIEW MODEL
  // ==========================================================

  Future<void> fetchServiceReviews(String serviceId) async {
    isFetchingReviews.value = true;
    try {
      final response = await http.get(
        Uri.parse(AppUrl.getReview(serviceId)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        serviceReviewsList.assignAll(
          jsonList.map((item) => ReviewModel.fromJson(item)).toList(),
        );
        log("Fetched ${serviceReviewsList.length} reviews for service $serviceId");
      }
    } catch (e) {
      log("Error fetching reviews: $e");
    } finally {
      isFetchingReviews.value = false;
    }
  }

  // ==========================================================
  // REVIEW DIALOG & SUBMIT METHODS
  // ==========================================================

  void openReviewDialog(String serviceId) {
    int selectedRating = 5;
    final commentController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Review",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Write your comment here...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColor.drawerGradient1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Cancel",
                          backgroundColor: Colors.grey.shade300,
                          textColor: Colors.grey.shade700,
                          onPressed: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(
                              () => CustomButton(
                            text: isSubmittingReview.value ? "Submitting..." : "Submit",
                            backgroundColor: AppColor.drawerGradient1,
                            textColor: Colors.white,
                            onPressed: () {
                              if (isSubmittingReview.value) return;

                              if (commentController.text.trim().isEmpty) {
                                CustomSnackbar(
                                  Get.context!,
                                  title: "Required",
                                  message: "Please enter a comment.",
                                  isError: true,
                                );
                                return;
                              }

                              _submitReviewApiCall(
                                serviceId: serviceId,
                                rating: selectedRating,
                                comment: commentController.text.trim(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _submitReviewApiCall({
    required String serviceId,
    required int rating,
    required String comment,
  }) async {
    isSubmittingReview.value = true;
    try {
      final token = AuthServices.getAccessToken();

      // Ensure service_id is sent as an integer
      final int parsedServiceId = int.tryParse(serviceId) ?? 1;

      final payload = {
        "service_id": parsedServiceId,
        "rating": rating,
        "comment": comment,
      };

      final response = await http.post(
        Uri.parse(AppUrl.addReview),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      log("Add review response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();

        CustomSnackbar(
          Get.context!,
          title: "Success",
          message: "Review submitted successfully.",
        );

        // Refresh reviews for this service
        fetchServiceReviews(serviceId);
      } else {
        final data = jsonDecode(response.body);
        CustomSnackbar(
          Get.context!,
          title: "Failed",
          message: data['detail'] ?? "Could not submit review.",
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar(
        Get.context!,
        title: "Error",
        message: "Something went wrong.",
        isError: true,
      );
    } finally {
      isSubmittingReview.value = false;
    }
  }
}