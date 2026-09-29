import 'package:flutter/material.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';

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
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() { isLoading = true; });
          },
          onPageFinished: (String url) {
            setState(() { isLoading = false; });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success') || request.url.contains('payment-success')) {
              Get.back(result: 'success');
              return NavigationDecision.prevent;
            }
            if (request.url.contains('fail') || request.url.contains('cancel')) {
              Get.back(result: 'fail');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: "Secure Payment"),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
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