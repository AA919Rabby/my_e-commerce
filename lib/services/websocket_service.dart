import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../presentation/cart/controller/cart_controller.dart';
import '../../presentation/notificatioon/controller/notification_controller.dart';
import '../../presentation/profile/controller/profile_controller.dart';
import '../core/config/app_url.dart';


class WebSocketService extends GetxService {
  WebSocketChannel? _channel;
  bool isConnected = false;

  @override
  void onInit() {
    super.onInit();
    connectServicesWebSocket();
  }

  void connectServicesWebSocket() {
    try {
      final uri = Uri.parse(AppUrl.servicesWs);
      _channel = WebSocketChannel.connect(uri);
      isConnected = true;
      log("🟢 WebSocket Connected to: ${AppUrl.servicesWs}");

      _channel!.stream.listen(
            (message) {
          log("⚡ [LIVE WS EVENT RECEIVED]: $message");
          _handleIncomingEvent(message);
        },
        onError: (error) {
          log("🔴 WebSocket Error: $error");
          isConnected = false;
          _reconnect();
        },
        onDone: () {
          log("🟡 WebSocket Closed. Reconnecting...");
          isConnected = false;
          _reconnect();
        },
      );
    } catch (e) {
      log("WebSocket Connection Exception: $e");
      _reconnect();
    }
  }

  void _handleIncomingEvent(dynamic rawMessage) {
    try {
      final Map<String, dynamic> data = jsonDecode(rawMessage);
      final String event = data['event'] ?? '';

      // 1. Live Notification Event -> Instantly fetch & update UI badge + trigger drop-down banner
      if (event == 'NEW_NOTIFICATION') {
        final notiController = NotificationController.to;
        notiController.fetchNotifications();

        // Also trigger the local drop-down notification banner directly from WS payload
        final String title = data['title'] ?? 'Notification';
        final String body = data['body'] ?? 'You have a new notification';
        final int id = data['notification_id'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

        notiController.showLocalNotification(
          id: id,
          title: title,
          body: body,
          payload: id.toString(),
        );
      }

      // 2. Live Profile Update Event -> Reload Profile Data
      // if (event == 'PROFILE_UPDATED') {
      //   if (Get.isRegistered<ProfileController>()) {
      //     Get.find<ProfileController>().fetchProfile();
      //   }
      // }

      // 3. Orders, Payments, & Reviews Live Events
      if (Get.isRegistered<CartController>()) {
        final cartController = Get.find<CartController>();

        if (event == 'NEW_ORDER' ||
            event == 'ORDER_STATUS_CHANGED' ||
            event == 'PAYMENT_UPDATE') {
          cartController.fetchPendingServices();
        }

        if (event == 'NEW_REVIEW' && data['service_id'] != null) {
          cartController.fetchServiceReviews(data['service_id'].toString());
        }
      }
    } catch (e) {
      log("Error parsing WS event: $e");
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!isConnected) {
        log("🔄 Retrying WebSocket connection...");
        connectServicesWebSocket();
      }
    });
  }

  @override
  void onClose() {
    _channel?.sink.close();
    super.onClose();
  }
}