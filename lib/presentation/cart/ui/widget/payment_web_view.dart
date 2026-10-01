import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    log("Initializing PaymentWebView with URL: ${widget.url}");

    final WebViewController controller = WebViewController();

    // Configure JavaScript and standard web navigation
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            log("Payment Page Started: $url");
            if (mounted) setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            log("Payment Page Finished: $url");
            if (mounted) setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            log("Payment WebView Error: ${error.description} (Code: ${error.errorCode})");
          },
          onNavigationRequest: (NavigationRequest request) {
            log("Payment Navigation Request: ${request.url}");

            // 1. Success Callback
            if (request.url.contains('payment/success') ||
                request.url.contains('success') ||
                request.url.contains('payment-success')) {
              Get.back(result: 'success');
              return NavigationDecision.prevent;
            }

            // 2. Failure or Cancellation Callback
            if (request.url.contains('payment/fail') ||
                request.url.contains('payment/cancel') ||
                request.url.contains('fail') ||
                request.url.contains('cancel')) {
              Get.back(result: 'fail');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    // CRUCIAL FOR ANDROID: Enable DOM Storage and third-party cookies for SSLCommerz scripts!
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      final androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    controller.loadRequest(Uri.parse(widget.url));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(result: 'fail'),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColor.drawerGradient1,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const CustomText(
          text: "Secure Payment",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CustomLoader(),
            ),
        ],
      ),
    );
  }
}