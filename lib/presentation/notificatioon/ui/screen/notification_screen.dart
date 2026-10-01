import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';
import '../../controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';

    try {
      DateTime date = DateTime.parse(dateStr);
      DateTime now = DateTime.now();

      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime notiDate = DateTime(date.year, date.month, date.day);

      Duration diff = today.difference(notiDate);

      if (diff.inDays == 0) {
        return 'Today';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else if (diff.inDays > 1 && diff.inDays <= 7) {
        return 'This week';
      } else if (now.year == date.year && now.month == date.month) {
        return 'This month';
      } else if (now.year == date.year) {
        return 'This year';
      } else if (now.year - date.year == 1) {
        return 'Last year';
      } else {
        String year = date.year.toString();
        String shortYear = year.length >= 2 ? year.substring(year.length - 2) : year;
        return '${date.day}/${date.month}/$shortYear';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.to;

    return Scaffold(
      backgroundColor: AppColor.text,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_outlined,color: AppColor.text),
        ),
        backgroundColor: AppColor.drawerGradient1,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColor.black),
        title: const CustomText(
          text: "Notifications",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.text,
        ),
        actions: [
          IconButton(
            onPressed: () => controller.markAllAsRead(),
            tooltip: "Mark all as read",
            icon: const Icon(Icons.done_all, color: AppColor.drawerGradient3),
          ),
          const Gap(10),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoader());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: CustomText(
              text: "No notifications yet",
              color: AppColor.secondaryText,
            ),
          );
        }

        return RefreshIndicator.adaptive(
          color: AppColor.drawerGradient1,
          onRefresh: () async {
            await controller.fetchNotifications();
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const Gap(16),
            itemBuilder: (context, index) {
              final noti = controller.notifications[index];

              return GestureDetector(
                onTap: () {
                  controller.markAsRead(noti.id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: noti.isRead
                        ? Colors.white
                        : AppColor.drawerGradient1.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: noti.isRead
                          ? Colors.transparent
                          : AppColor.drawerGradient1.withOpacity(0.5),
                    ),
                    boxShadow: noti.isRead
                        ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : [],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: noti.isRead
                              ? AppColor.background.withOpacity(0.05)
                              : AppColor.drawerGradient1.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          noti.isRead
                              ? Icons.notifications_none_rounded
                              : Icons.notifications_active_rounded,
                          color: noti.isRead
                              ? AppColor.secondaryText
                              : AppColor.drawerGradient1,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: noti.title,
                                    fontSize: 16,
                                    fontWeight: noti.isRead
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                                    color: AppColor.black,
                                  ),
                                ),
                                const Gap(8),
                                CustomText(
                                  text: _formatDate(noti.createdAt),
                                  fontSize: 11,
                                  color: AppColor.secondaryText,
                                ),
                              ],
                            ),
                            const Gap(6),
                            CustomText(
                              text: noti.subtitle,
                              fontSize: 13,
                              color: AppColor.secondaryText,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      if (!noti.isRead)
                        Container(
                          margin: const EdgeInsets.only(left: 8, top: 4),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}