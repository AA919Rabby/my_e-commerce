import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../global/custom_text.dart';
import '../../../../global/custom_text_field.dart';
import '../../../../global/custom_button.dart';
import '../../controller/cart_controller.dart';

class PushServices extends StatelessWidget {
  PushServices({super.key});

  final String productId = Get.arguments.toString();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColor.text,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_outlined),
        ),
        title: const CustomText(
          text: "Book Service",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
        backgroundColor: AppColor.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColor.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(text: "Full Name", color: AppColor.black, fontWeight: FontWeight.bold),
                const Gap(8),
                CustomTextField(
                  controller: controller.nameController,
                  hintText: "Full Name",
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 4) return "Required";
                    return null;
                  },
                ),
                const Gap(16),

                const CustomText(text: "Age", color: AppColor.black, fontWeight: FontWeight.bold),
                const Gap(8),
                CustomTextField(
                  controller: controller.ageController,
                  hintText: "Age",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Required";
                    final age = int.tryParse(value);
                    if (age == null || age < 10) return "Minimum 10";
                    return null;
                  },
                ),
                const Gap(16),

                const CustomText(text: "Address", color: AppColor.black, fontWeight: FontWeight.bold),
                const Gap(8),
                CustomTextField(
                  controller: controller.addressController,
                  hintText: "Street address",
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 4) return "Required";
                    return null;
                  },
                ),
                const Gap(16),

                const CustomText(text: "Postcode", color: AppColor.black, fontWeight: FontWeight.bold),
                const Gap(8),
                CustomTextField(
                  controller: controller.postcodeController,
                  hintText: "Postcode",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 4) return "Required";
                    return null;
                  },
                ),
                const Gap(16),

                const CustomText(text: "Phone Number", color: AppColor.black, fontWeight: FontWeight.bold),
                const Gap(8),
                CustomTextField(
                  controller: controller.phoneController,
                  hintText: "Phone number",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Required";
                    final num = int.tryParse(value);
                    if (num == null || num < 11) return "Minimum 11";
                    return null;
                  },
                ),
                const Gap(40),

                Obx(() {
                  if (controller.isLoading.value) {
                    return CustomButton(
                      text: "Processing...",
                      textColor: AppColor.text,
                      onPressed: () {},
                      backgroundColor: AppColor.drawerGradient1 ,
                    );
                  }

                  return CustomButton(
                    text: "Confirm Booking",
                    textColor: AppColor.text,
                    onPressed: () {
                      controller.submitServiceOrder(productId);
                    },
                    backgroundColor: AppColor.drawerGradient1 ,
                  );
                }),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}