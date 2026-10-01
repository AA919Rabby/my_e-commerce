import 'package:flutter/material.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

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
          onPageStarted: (String url) { setState(() { isLoading = true; }); },
          onPageFinished: (String url) { setState(() { isLoading = false; }); },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success') || request.url.contains('payment-success')) { Get.back(result: 'success'); return NavigationDecision.prevent; }
            if (request.url.contains('fail') || request.url.contains('cancel')) { Get.back(result: 'fail'); return NavigationDecision.prevent; }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121421), // Nighty background
      appBar: AppBar(
        leading: InkWell(onTap: ()=>Get.back(), child: const Icon(Icons.arrow_back, color: Colors.white)),
        backgroundColor: AppColor.drawerGradient1,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const CustomText(text: "Secure Payment",
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CustomLoader()),
        ],
      ),
    );
  }
}