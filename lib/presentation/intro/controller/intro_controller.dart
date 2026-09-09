import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Mixin GetSingleTickerProviderStateMixin allows this controller to handle animations
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

    // Optional: Add logic to navigate to the next screen after a few seconds
    // Future.delayed(const Duration(seconds: 4), () {
    //   Get.offNamed('/home');
    // });
  }

  @override
  void onClose() {
    // ALWAYS dispose the animation controller to prevent memory leaks
    animationController.dispose();
    super.onClose();
  }
}