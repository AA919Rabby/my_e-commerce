import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/local_db/auth_services.dart'; // Import AuthServices
import 'package:mye_commerce/all_route.dart'; // Import your routes

class IntroController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();

    // 1. Initialize the AnimationController
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 Sec animation
    )..repeat(reverse: true); // repeat with reverse creates the endless loop

    // 2. Define the Tween (Scaling from 90% to 110%)
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 3. Check login status after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      final token = AuthServices.getAccessToken();

      // If token exists and isn't empty, user is already logged in
      if (token != null && token.isNotEmpty) {
        // Route to your Bottom Navigation Screen
        // Note: Make sure 'AllRoute.bottomNav' matches your exact variable name in all_route.dart
        Get.offAllNamed(AllRoute.bottomNav);
      } else {
        // Not logged in, route to Login Screen
        Get.offAllNamed(AllRoute.login);
      }
    });
  }

  @override
  void onClose() {
    // ALWAYS dispose the animation controller to prevent memory leaks
    animationController.dispose();
    super.onClose();
  }
}