import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Make sure to import your AllRoute file here
// import 'package:mye_commerce/routes/all_route.dart';

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

    // ADDED: 3 second timer to route to the login screen
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/login'); // Routes to login and removes IntroScreen from memory
    });
  }

  @override
  void onClose() {
    // ALWAYS dispose the animation controller to prevent memory leaks
    animationController.dispose();
    super.onClose();
  }
}