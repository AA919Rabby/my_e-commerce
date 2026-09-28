import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';

import '../../controller/notification_controller.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColor.text,
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_outlined)),
        backgroundColor: AppColor.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColor.black),
        title: const CustomText(
          text: "Notifications",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
        actions: [
          IconButton(
            onPressed: () => controller.markAllAsRead(),
            tooltip: "Mark all as read",
            icon: const Icon(Icons.done_all, color: AppColor.drawerGradient1),
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
                    boxShadow: noti.isRead ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ] : [],
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
                          noti.isRead ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                          color: noti.isRead ? AppColor.secondaryText : AppColor.drawerGradient1,
                        ),
                      ),
                      const Gap(16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: noti.title,
                              fontSize: 16,
                              fontWeight: noti.isRead ? FontWeight.w600 : FontWeight.bold,
                              color: AppColor.black,
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
                          margin: const EdgeInsets.only(top: 8),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColor.danger,
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