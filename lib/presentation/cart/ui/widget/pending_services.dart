import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_snackbar.dart';

import '../../../../global/custom_confirm_dialog.dart';
import '../../../../global/custom_divider.dart';
import '../../controller/cart_controller.dart';

class PendingServices extends StatelessWidget {
  const PendingServices({super.key});

  String _getName(String? fullAddress) {
    if (fullAddress == null || fullAddress.trim().isEmpty) return 'N/A';
    final parts = fullAddress.split(',');
    if (parts.isNotEmpty) {
      return parts.first.trim();
    }
    return 'N/A';
  }

  String _getStreetAddress(String? fullAddress) {
    if (fullAddress == null || fullAddress.trim().isEmpty) return 'N/A';
    final parts = fullAddress.split(',');

    if (parts.length > 3) {
      return parts.sublist(1, parts.length - 2).join(',').trim();
    } else if (parts.length > 1) {
      return parts[1].trim();
    }
    return 'N/A';
  }

  String _getPostcode(String? fullAddress) {
    if (fullAddress == null || fullAddress.trim().isEmpty) return 'N/A';
    final parts = fullAddress.split(',');

    if (parts.length >= 3) {
      return parts[parts.length - 2].trim();
    }
    return 'N/A';
  }

  String _getFormattedDate(dynamic service) {
    try {
      String? dateString;

      // Safely check common date properties individually to prevent crashes
      try { dateString ??= service.createdAt?.toString(); } catch (_) {}
      try { dateString ??= service.created_at?.toString(); } catch (_) {}
      try { dateString ??= service.date?.toString(); } catch (_) {}
      try { dateString ??= service.updatedAt?.toString(); } catch (_) {}

      // Fallback: Check raw JSON if the model has a toJson method
      if (dateString == null) {
        try {
          final json = service.toJson();
          dateString = (json['created_at'] ?? json['createdAt'] ?? json['date'])?.toString();
        } catch (_) {}
      }

      if (dateString == null || dateString.trim().isEmpty || dateString == 'null') {
        return 'N/A';
      }

      final parsed = DateTime.tryParse(dateString);
      if (parsed != null) {
        return "${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}";
      }
      return dateString;
    } catch (_) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Obx(() {
      if (controller.isFetchingPending.value) {
        return const Center(
          child: CustomLoader(),
        );
      }

      if (controller.pendingServicesList.isEmpty) {
        return const Center(
          child: CustomText(
            text: "No pending orders",
            color: AppColor.secondaryText,
            fontSize: 16,
          ),
        );
      }

      return RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () async {
          await controller.fetchPendingServices();
        },
        child: ListView.separated(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.pendingServicesList.length,
          separatorBuilder: (context, index) => const Gap(16),
          itemBuilder: (context, index) {
            final service = controller.pendingServicesList[index];

            final customerName = _getName(service.serviceAddress);
            final streetAddress = _getStreetAddress(service.serviceAddress);
            final postcode = _getPostcode(service.serviceAddress);
            final dateText = _getFormattedDate(service);

            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColor.secondaryText.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Total Amount: ৳${service.totalAmount ?? 0}",
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomText(
                          text: service.status ?? "PENDING",
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),

                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: AppColor.secondaryText,
                      ),
                      const Gap(6),
                      CustomText(
                        text: customerName,
                        fontSize: 14,
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const Gap(6),

                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: AppColor.secondaryText,
                      ),
                      const Gap(6),
                      CustomText(
                        text: service.customerPhone ?? "N/A",
                        fontSize: 14,
                        color: AppColor.secondaryText,
                      ),
                    ],
                  ),
                  const Gap(6),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColor.secondaryText,
                      ),
                      const Gap(6),
                      Expanded(
                        child: CustomText(
                          text: streetAddress,
                          fontSize: 14,
                          color: AppColor.secondaryText,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Gap(6),

                  Row(
                    children: [
                      const Icon(
                        Icons.markunread_mailbox_outlined,
                        size: 16,
                        color: AppColor.secondaryText,
                      ),
                      const Gap(6),
                      CustomText(
                        text: "Postcode: $postcode",
                        fontSize: 14,
                        color: AppColor.secondaryText,
                      ),
                    ],
                  ),
                  const Gap(6),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColor.secondaryText,
                      ),
                      const Gap(6),
                      CustomText(
                        text: "Date: $dateText",
                        fontSize: 14,
                        color: AppColor.secondaryText,
                      ),
                    ],
                  ),
                  const Gap(16),

                  const CustomDivider(),
                  const Gap(12),

                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final bool isThisItemPaying = controller.payingOrderId.value == service.id.toString();
                          final bool isAnyPaymentInProgress = controller.payingOrderId.isNotEmpty;

                          return CustomButton(
                            text: isThisItemPaying ? "Loading..." : "Pay Now",
                            backgroundColor: AppColor.primary,
                            textColor: Colors.white,
                            onPressed: () {
                              if (isAnyPaymentInProgress) return;

                              if (service.id != null) {
                                controller.initiatePayment(service.id.toString());
                              } else {
                                CustomSnackbar(
                                  Get.context!,
                                  title: "Error",
                                  message: "Order ID missing",
                                  isError: true,
                                );
                              }
                            },
                          );
                        }),
                      ),
                      const Gap(8),

                      // ==========================================
                      // FIX IS HERE - changed item to service
                      // ==========================================
                      Expanded(
                        child: CustomButton(
                          text: "Review",
                          backgroundColor: AppColor.drawerGradient1,
                          textColor: AppColor.text,
                          onPressed: () {
                            // Use serviceId if available, fallback to service.id
                            final targetServiceId = service.serviceId?.toString() ?? service.id.toString();
                            if (targetServiceId.isNotEmpty) {
                              controller.openReviewDialog(targetServiceId);
                            } else {
                              CustomSnackbar(
                                Get.context!,
                                title: "Error",
                                message: "Service ID missing",
                                isError: true,
                              );
                            }
                          },
                        ),
                      ),
                      const Gap(8),

                      Expanded(
                        child: CustomButton(
                          text: "Cancel",
                          backgroundColor: AppColor.danger,
                          textColor: AppColor.text,
                          onPressed: () {
                            CustomConfirmDialog.show(
                              context: context,
                              title: "Cancel Order?",
                              icon: Icons.warning_amber_rounded,
                              iconColor: AppColor.danger,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: "No",
                                      backgroundColor: AppColor.secondaryText,
                                      textColor: Colors.white,
                                      height: 44,
                                      borderRadius: 8,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: CustomButton(
                                      text: "Yes, Cancel",
                                      backgroundColor: AppColor.danger,
                                      textColor: AppColor.text,
                                      height: 44,
                                      borderRadius: 8,
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        if (service.id != null) {
                                          await controller.cancelServiceOrder(service.id.toString());
                                        } else {
                                          CustomSnackbar(
                                            Get.context!,
                                            title: "Error",
                                            message: "Order ID missing",
                                            isError: true,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}