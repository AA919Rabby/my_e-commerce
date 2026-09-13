import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';

import '../../controller/intro_controller.dart';



class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IntroController>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.drawerGradient1,
              AppColor.drawerGradient2,
              AppColor.drawerGradient3,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // AnimatedBuilder listens to the GetX Controller's animation
              Center(
                child: AnimatedBuilder(
                  animation: controller.scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: controller.scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: CustomText(
                    text: "My E-Commerce",
                    color: AppColor.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),

              const Spacer(),
              const CustomLoader(),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}