// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_gap/flutter_gap.dart';
// import 'package:mye_commerce/core/theme/app_color.dart';
// import 'package:mye_commerce/global/custom_text.dart';
// import 'package:mye_commerce/global/custom_loader.dart';
//
// import '../../controller/cart_controller.dart';
//
// class CompleteServices extends StatelessWidget {
//   const CompleteServices({super.key});
//
//   String _getName(String? fullAddress) {
//     if (fullAddress == null || fullAddress.trim().isEmpty) return 'N/A';
//     final parts = fullAddress.split(',');
//     if (parts.isNotEmpty) {
//       return parts.first.trim();
//     }
//     return 'N/A';
//   }
//
//   String _getStreetAddress(String? fullAddress) {
//     if (fullAddress == null || fullAddress.trim().isEmpty) return 'N/A';
//     final parts = fullAddress.split(',');
//
//     if (parts.length > 3) {
//       return parts.sublist(1, parts.length - 2).join(',').trim();
//     } else if (parts.length > 1) {
//       return parts[1].trim();
//     }
//     return 'N/A';
//   }
//
//   String _getPostcode(String? fullAddress) {
//     if (fullAddress == null || fullAddress.trim().isEmpty) return 'N/A';
//     final parts = fullAddress.split(',');
//
//     if (parts.length >= 3) {
//       return parts[parts.length - 2].trim();
//     }
//     return 'N/A';
//   }
//
//   String _getFormattedDate(dynamic service) {
//     try {
//       String? dateString;
//
//       // Safely check common date properties individually to prevent crashes
//       try { dateString ??= service.createdAt?.toString(); } catch (_) {}
//       try { dateString ??= service.created_at?.toString(); } catch (_) {}
//       try { dateString ??= service.date?.toString(); } catch (_) {}
//       try { dateString ??= service.updatedAt?.toString(); } catch (_) {}
//
//       // Fallback: Check raw JSON if the model has a toJson method
//       if (dateString == null) {
//         try {
//           final json = service.toJson();
//           dateString = (json['created_at'] ?? json['createdAt'] ?? json['date'])?.toString();
//         } catch (_) {}
//       }
//
//       if (dateString == null || dateString.trim().isEmpty || dateString == 'null') {
//         return 'N/A';
//       }
//
//       final parsed = DateTime.tryParse(dateString);
//       if (parsed != null) {
//         return "${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}";
//       }
//       return dateString;
//     } catch (_) {
//       return 'N/A';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<CartController>();
//
//     return Obx(() {
//       if (controller.isFetchingPending.value) {
//         return const Center(
//           child: CustomLoader(),
//         );
//       }
//
//       if (controller.completedServicesList.isEmpty) {
//         return const Center(
//           child: CustomText(
//             text: "No completed orders",
//             color: AppColor.secondaryText,
//             fontSize: 16,
//           ),
//         );
//       }
//
//       return RefreshIndicator(
//         color: AppColor.primary,
//         onRefresh: () async {
//           await controller.fetchPendingServices();
//         },
//         child: ListView.separated(
//           padding: const EdgeInsets.all(16.0),
//           itemCount: controller.completedServicesList.length,
//           separatorBuilder: (context, index) => const Gap(16),
//           itemBuilder: (context, index) {
//             final service = controller.completedServicesList[index];
//
//             final customerName = _getName(service.serviceAddress);
//             final streetAddress = _getStreetAddress(service.serviceAddress);
//             final postcode = _getPostcode(service.serviceAddress);
//             final dateText = _getFormattedDate(service);
//
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: AppColor.secondaryText.withOpacity(0.2),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomText(
//                         text: "Total Amount: ৳${service.totalAmount ?? 0}",
//                         color: AppColor.primary,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: CustomText(
//                           text: "COMPLETED",
//                           color: Colors.green,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Gap(12),
//
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.person_outline,
//                         size: 16,
//                         color: AppColor.secondaryText,
//                       ),
//                       const Gap(6),
//                       CustomText(
//                         text: customerName,
//                         fontSize: 14,
//                         color: AppColor.black,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ],
//                   ),
//                   const Gap(6),
//
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.phone,
//                         size: 16,
//                         color: AppColor.secondaryText,
//                       ),
//                       const Gap(6),
//                       CustomText(
//                         text: service.customerPhone ?? "N/A",
//                         fontSize: 14,
//                         color: AppColor.secondaryText,
//                       ),
//                     ],
//                   ),
//                   const Gap(6),
//
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         size: 16,
//                         color: AppColor.secondaryText,
//                       ),
//                       const Gap(6),
//                       Expanded(
//                         child: CustomText(
//                           text: streetAddress,
//                           fontSize: 14,
//                           color: AppColor.secondaryText,
//                           maxLines: 2,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Gap(6),
//
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.markunread_mailbox_outlined,
//                         size: 16,
//                         color: AppColor.secondaryText,
//                       ),
//                       const Gap(6),
//                       CustomText(
//                         text: "Postcode: $postcode",
//                         fontSize: 14,
//                         color: AppColor.secondaryText,
//                       ),
//                     ],
//                   ),
//                   const Gap(6),
//
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_today_outlined,
//                         size: 16,
//                         color: AppColor.secondaryText,
//                       ),
//                       const Gap(6),
//                       CustomText(
//                         text: "Date: $dateText",
//                         fontSize: 14,
//                         color: AppColor.secondaryText,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       );
//     });
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/global/custom_loader.dart';

import '../../controller/cart_controller.dart';

class CompleteServices extends StatelessWidget {
  const CompleteServices({super.key});

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
      try { dateString ??= service.createdAt?.toString(); } catch (_) {}
      try { dateString ??= service.created_at?.toString(); } catch (_) {}
      try { dateString ??= service.date?.toString(); } catch (_) {}
      try { dateString ??= service.updatedAt?.toString(); } catch (_) {}

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

  Widget _buildInfoRow(IconData icon, String text, {bool isExpanded = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColor.drawerGradient1.withOpacity(0.7)),
        const Gap(10),
        isExpanded
            ? Expanded(child: CustomText(text: text, fontSize: 14, color: AppColor.secondaryText, maxLines: 2))
            : CustomText(text: text, fontSize: 14, color: AppColor.secondaryText),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Obx(() {
      if (controller.isFetchingPending.value) {
        return const Center(child: CustomLoader());
      }

      if (controller.completedServicesList.isEmpty) {
        return const Center(
          child: CustomText(text: "No completed orders", color: AppColor.secondaryText, fontSize: 16),
        );
      }

      return RefreshIndicator(
        color: AppColor.drawerGradient1,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await controller.fetchPendingServices();
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.completedServicesList.length,
          separatorBuilder: (context, index) => const Gap(16),
          itemBuilder: (context, index) {
            final service = controller.completedServicesList[index];

            final customerName = _getName(service.serviceAddress);
            final streetAddress = _getStreetAddress(service.serviceAddress);
            final postcode = _getPostcode(service.serviceAddress);
            final dateText = _getFormattedDate(service);

            return Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white, // Light mode
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.drawerGradient1.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
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
                        text: "Total: ৳${service.totalAmount ?? 0}",
                        color: AppColor.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.2)),
                        ),
                        child: const CustomText(
                          text: "COMPLETED",
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),

                  _buildInfoRow(Icons.person_outline, customerName),
                  const Gap(10),
                  _buildInfoRow(Icons.phone_outlined, service.customerPhone ?? "N/A"),
                  const Gap(10),
                  _buildInfoRow(Icons.location_on_outlined, streetAddress, isExpanded: true),
                  const Gap(10),
                  _buildInfoRow(Icons.markunread_mailbox_outlined, "Postcode: $postcode"),
                  const Gap(10),
                  _buildInfoRow(Icons.calendar_today_outlined, "Date: $dateText"),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}