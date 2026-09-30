import 'dart:async';
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
  // Permanent instance accessible anywhere in the app
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

  // Timer for automatic periodic fetching in background
  Timer? _pollingTimer;

  // Badge count: dynamically counts unread notifications
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    initLocalNotifications();
    fetchNotifications();

    // Periodically fetch every 10 seconds to detect new notifications automatically
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchNotifications(isBackground: true);
    });
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  /// Initialize Flutter Local Notification and register Channel on Android OS
  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

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
        Get.toNamed(AllRoute.notification);
      },
    );

    // Explicitly create and register high-importance channel with Android OS
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // 1. Request Android 13+ runtime permission
      await androidImplementation.requestNotificationsPermission();

      // 2. Create OS Channel (Using v2 to bypass cached OS channel settings)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel_v2', // Updated Channel ID
        'High Importance Notifications',
        description: 'This channel is used for important notification alerts.',
        importance: Importance.max, // MUST be max for heads-up banner
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await androidImplementation.createNotificationChannel(channel);
    }
  }

  /// Show Local Notification Banner that drops down from the top
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
      log("Note: asset/toolbox.png not loaded, using default icon. Error: $e");
    }

    // Heads-up drop down notification configuration
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel_v2', // MUST match initLocalNotifications channel ID
      'High Importance Notifications',
      channelDescription:
      'This channel is used for important notification alerts.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/launcher_icon',
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

    try {
      // Fixed syntax error: parameters passed using named syntax
      await flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
      log("🔔 Heads-up drop-down banner displayed: $title");
    } catch (e) {
      log("Error showing local notification banner: $e");
    }
  }

  Future<void> fetchNotifications({bool isBackground = false}) async {
    if (!isBackground && notifications.isEmpty) {
      isLoading.value = true;
    }

    try {
      final token = AuthServices.getAccessToken();
      if (token == null || token.isEmpty) return;

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

        // Check for new incoming notifications and trigger top banner
        for (var noti in fetchedList) {
          if (!_shownNotificationIds.contains(noti.id)) {
            _shownNotificationIds.add(noti.id);

            // Trigger top drop-down banner if unread
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

        // assignAll notifies GetX to update the badge count immediately
        notifications.assignAll(fetchedList);
      } else {
        log("Failed to load notifications: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching notifications: $e");
    } finally {
      if (!isBackground) {
        isLoading.value = false;
      }
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