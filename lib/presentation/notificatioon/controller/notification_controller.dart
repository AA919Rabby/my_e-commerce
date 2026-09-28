import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mye_commerce/core/config/app_url.dart';
import 'package:mye_commerce/local_db/auth_services.dart';
import '../data/notification_model.dart';
// Import your Auth/LocalDB service here to get the token
// import '../../local_db/auth_services.dart';

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

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        notifications.value = data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        // Handle API error
        log("Failed to load notifications: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Updates UI locally when tapped, you can also add an HTTP PATCH request
  // here if your API requires updating the read status on the server
  void markAsRead(String id) {
    int index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);

      // Example server update:
      // http.patch(Uri.parse('https://fastapi-crud-y254.onrender.com/api/v1/notifications/$id/read'), ...);
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
  }
}