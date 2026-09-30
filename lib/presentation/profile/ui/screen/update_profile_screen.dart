import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_image_picker_sheet.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/global/custom_text_field.dart';
import 'package:mye_commerce/presentation/profile/controller/profile_controller.dart';



class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColor.text,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
        title: const CustomText(
          text: "Update Profile",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: controller.updateProfileFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),

              // ================= IMAGE PICKER SECTION =================
              Center(
                child: GestureDetector(
                  onTap: () {
                    CustomImagePickerSheet.show(
                      onPick: (source) {
                        controller.pickImage(source);
                      },
                    );
                  },
                  child: Obx(() {
                    final networkUrl = controller.profile.value?.profilePictureUrl ?? '';
                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 120.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                            color: AppColor.drawerGradient1.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.drawerGradient1,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: controller.profileImage.value != null
                                ? Image.file(
                              controller.profileImage.value!,
                              fit: BoxFit.cover,
                            )
                                : (networkUrl.isNotEmpty
                                ? Image.network(
                              networkUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                size: 60.sp,
                                color: AppColor.drawerGradient1,
                              ),
                            )
                                : Icon(
                              Icons.person,
                              size: 60.sp,
                              color: AppColor.drawerGradient1,
                            )),
                          ),
                        ),
                        Container(
                          height: 35.h,
                          width: 35.w,
                          decoration: const BoxDecoration(
                            color: AppColor.drawerGradient1,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, color: Colors.white, size: 18.sp),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const Gap(30),

              // ================= FULL NAME WITH FORM VALIDATION =================
              const CustomText(
                text: "Full Name",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
              const Gap(8),
              CustomTextField(
                controller: controller.nameController,
                hintText: "Enter full name",
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColor.secondaryText,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  if (value.trim().length < 4) {
                    return 'Minimum 4 characters';
                  }
                  return null;
                },
              ),
              const Gap(20),

              // ================= PHONE NUMBER WITH FORM VALIDATION =================
              const CustomText(
                text: "Phone Number",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
              const Gap(8),
              CustomTextField(
                controller: controller.phoneController,
                hintText: "Enter phone number",
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  color: AppColor.secondaryText,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final phoneRegex = RegExp(r'^[0-9]+$');
                  if (!phoneRegex.hasMatch(value.trim()) || value.trim().length < 11) {
                    return 'Minimum 11 digits';
                  }
                  return null;
                },
              ),
              const Gap(20),

              // ================= ADDRESS WITH FORM VALIDATION =================
              const CustomText(
                text: "Address",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
              const Gap(8),
              CustomTextField(
                controller: controller.addressController,
                hintText: "Enter address",
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColor.secondaryText,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  if (value.trim().length < 4) {
                    return 'Minimum 4 characters';
                  }
                  return null;
                },
              ),

              const Gap(40),

              // ================= UPDATE BUTTON =================
              Obx(() {
                if (controller.isUpdating.value) {
                  return Center(
                    child: CustomButton(
                      text: "Updating...",
                      backgroundColor: AppColor.drawerGradient1,
                      textColor: AppColor.text,
                      onPressed: () {},
                    ),
                  );
                }
                return CustomButton(
                  text: "Update Profile",
                  backgroundColor: AppColor.drawerGradient1,
                  textColor: AppColor.text,
                  onPressed: () {
                    controller.updateProfile();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}