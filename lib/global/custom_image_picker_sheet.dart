import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_text.dart';

class CustomImagePickerSheet {
  static void show({required Function(ImageSource) onPick}) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            const Gap(20),
            CustomText(
              text: "Select Image Source",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Get.back(); // Close sheet
                    onPick(ImageSource.camera);
                  },
                ),
                _buildOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    Get.back(); // Close sheet
                    onPick(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const Gap(20),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget _buildOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: AppColor.drawerGradient1.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.drawerGradient1, size: 30.sp),
          ),
          const Gap(10),
          CustomText(
            text: label,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.black,
          ),
        ],
      ),
    );
  }
}