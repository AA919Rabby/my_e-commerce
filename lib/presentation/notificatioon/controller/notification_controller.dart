import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mye_commerce/core/config/app_url.dart';
import 'package:mye_commerce/local_db/auth_services.dart';
import '../data/notification_model.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final token = AuthServices.getAccessToken();

      final response = await http.get(
        Uri.parse(AppUrl.notification),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log("Notifications API Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        notifications.value = data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        log("Failed to load notifications: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void markAsRead(String id) async {
    int index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);

      try {
        final token = AuthServices.getAccessToken();
        await http.patch(
          Uri.parse('${AppUrl.notification}/$id/read'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        log("Error marking notification read on server: $e");
      }
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        markAsRead(notifications[i].id);
      }
    }
  }
}