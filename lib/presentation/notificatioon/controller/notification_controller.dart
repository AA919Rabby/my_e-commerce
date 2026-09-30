import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mye_commerce/all_route.dart';
import 'package:mye_commerce/core/config/app_url.dart';
import 'package:mye_commerce/local_db/auth_services.dart';
import '../data/notification_model.dart';

class NotificationController extends GetxController {
  // Makes sure the controller is permanent and always accessible anywhere in the app
  static NotificationController get to {
    if (Get.isRegistered<NotificationController>()) {
      return Get.find<NotificationController>();
    } else {
      return Get.put(NotificationController(), permanent: true);
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;

  // Track notifications already shown to avoid duplicate popups
  final Set<String> _shownNotificationIds = <String>{};

  // Badge count: dynamically counts only unread notifications (1, 2, ...)
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    initLocalNotifications();
    fetchNotifications();
  }

  /// Initialize Flutter Local Notification and request permissions
  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // When notification pop-up banner is clicked, open NotificationScreen
        Get.toNamed(AllRoute.notification);
      },
    );

    // Request Android 13+ Notification Permission
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  /// Show Local Notification with Title, Description and asset/toolbox.png
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    ByteArrayAndroidBitmap? largeIconBitmap;
    try {
      final ByteData byteData = await rootBundle.load('asset/toolbox.png');
      final Uint8List bytes = byteData.buffer.asUint8List();
      largeIconBitmap = ByteArrayAndroidBitmap(bytes);
    } catch (e) {
      log("Error loading asset/toolbox.png: $e");
    }

    // Creating channel with MAX importance so it drops down from top of the screen
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Notifications alerts channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      largeIcon: largeIconBitmap,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
      ),
    );

    const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

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
        List<NotificationModel> fetchedList =
        data.map((json) => NotificationModel.fromJson(json)).toList();

        // Check for new incoming notifications and trigger local banner
        for (var noti in fetchedList) {
          if (!_shownNotificationIds.contains(noti.id)) {
            _shownNotificationIds.add(noti.id);

            // Pop up banner if unread
            if (!noti.isRead) {
              showLocalNotification(
                id: noti.id.hashCode,
                title: noti.title,
                body: noti.subtitle,
                payload: noti.id,
              );
            }
          }
        }

        // assignAll() notifies GetX to rebuild the badge count immediately
        notifications.assignAll(fetchedList);
      } else {
        log("Failed to load notifications: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Mark as read when notification is clicked
  void markAsRead(String id) async {
    int index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh();

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

  /// Mark all notifications read
  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        markAsRead(notifications[i].id);
      }
    }
  }
}