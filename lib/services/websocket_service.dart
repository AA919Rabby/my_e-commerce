import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:mye_commerce/core/config/app_url.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../presentation/cart/controller/cart_controller.dart';


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

      // Check if CartController is active
      if (Get.isRegistered<CartController>()) {
        final cartController = Get.find<CartController>();

        // 1. Order or Payment update -> Refresh orders list!
        if (event == 'NEW_ORDER' ||
            event == 'ORDER_STATUS_CHANGED' ||
            event == 'PAYMENT_UPDATE') {
          cartController.fetchPendingServices();
        }

        // 2. New Review posted -> Refresh reviews live!
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