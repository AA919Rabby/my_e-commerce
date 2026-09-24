import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/global/custom_text_field.dart'; // Assuming you have this
import 'package:mye_commerce/presentation/profile/controller/profile_controller.dart';
// Import your custom bottom sheet
import 'package:mye_commerce/global/custom_image_picker_sheet.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller here if not injected in binding, or use Get.find()
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColor.text, // Assuming AppColor.text is background color (white/light)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.black),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Update Profile",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            const Gap(30),

            // ================= IMAGE PICKER SECTION =================
            Center(
              child: GestureDetector(
                onTap: () {
                  // CALL YOUR CUSTOM BOTTOM SHEET
                  CustomImagePickerSheet.show(
                    onPick: (source) {
                      controller.pickImage(source);
                    },
                  );
                },
                child: Obx(() {
                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 120.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: AppColor.drawerGradient1.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.drawerGradient1, width: 2),
                        ),
                        child: controller.profileImage.value != null
                        // Show selected File Image
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: Image.file(
                            controller.profileImage.value!,
                            fit: BoxFit.cover,
                          ),
                        )
                        // Show placeholder icon
                            : Icon(
                          Icons.person,
                          size: 60.sp,
                          color: AppColor.drawerGradient1,
                        ),
                      ),
                      // Edit Icon Badge
                      Container(
                        height: 35.h,
                        width: 35.w,
                        decoration: const BoxDecoration(
                          color: AppColor.drawerGradient1, // Or AppColor.black
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit, color: Colors.white, size: 18.sp),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const Gap(40),

            // ================= TEXT FIELDS SECTION =================
            // Based on Postman bodyData: "proffesion"
            CustomText(
              text: "Profession",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
            const Gap(10),
            CustomTextField(
              controller: controller.professionController,
              hintText: "Enter your profession",
              prefixIcon: Icons.work_outline,
            ),

            const Gap(50),

            // ================= UPDATE BUTTON =================
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CustomLoader(color: AppColor.drawerGradient1));
              }
              return CustomButton(
                text: "Update Profile",
                backgroundColor: AppColor.drawerGradient1,
                textColor: AppColor.black,
                onPressed: () {
                  controller.updateProfile();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}