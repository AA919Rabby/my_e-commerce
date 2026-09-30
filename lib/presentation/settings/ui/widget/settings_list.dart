import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/all_route.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_confirm_dialog.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/local_db/auth_services.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  // Reusable tile widget matching your app theme
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    bool isDanger = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColor.drawerGradient1).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 22.sp,
            color: iconColor ?? AppColor.drawerGradient1,
          ),
        ),
        title: CustomText(
          text: title,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColor.black,
        ),
        trailing: Icon(
          Icons.arrow_forward,
          size: 16.sp,
          color: isDanger ? AppColor.danger : AppColor.secondaryText,
        ),
        onTap: onTap,
      ),
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    CustomConfirmDialog.show(
      context: context,
      title: "Logout Account?",
      icon: Icons.logout_rounded,
      iconColor: AppColor.danger,
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "Cancel",
              backgroundColor: AppColor.secondaryText,
              textColor: Colors.white,
              height: 44,
              borderRadius: 8,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Gap(10),
          Expanded(
            child: CustomButton(
              text: "Yes, Logout",
              backgroundColor: AppColor.danger,
              textColor: Colors.white,
              height: 44,
              borderRadius: 8,
              onPressed: () async {
                Navigator.pop(context);
                // Clear saved auth credentials
                await AuthServices.clearAll();
                // Navigate back to login
                Get.offAllNamed(AllRoute.login);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Simple Info Dialog for Terms of Service & About Us
  void _showInfoDialog(String title, String content) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
              const Gap(12),
              CustomText(
                text: content,
                fontSize: 13,
                color: AppColor.black.withValues(alpha: 0.5),
                maxLines: 15,
              ),
              const Gap(20),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  text: "Close",
                  width: 90,
                  height: 38,
                  backgroundColor: AppColor.drawerGradient1,
                  textColor: Colors.white,
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Profile
        _buildSettingTile(
          icon: Icons.person_outline_rounded,
          title: "Profile",
          onTap: () {
            Get.toNamed(AllRoute.myProfile);
          },
        ),

        // 2. Update Profile
        _buildSettingTile(
          icon: Icons.edit_note_rounded,
          title: "Update Profile",
          onTap: () {
            Get.toNamed(AllRoute.updateProfile);
          },
        ),

        // 3. Terms of Service
        _buildSettingTile(
          icon: Icons.description_outlined,
          title: "Terms of Service",
          onTap: () {
            _showInfoDialog(
              "Terms of Service",
              "1. Acceptance of Terms: By booking any service on this platform, you agree to our policies.\n\n"
                  "2. Cancellations: Bookings can be cancelled only while in 'PENDING' status.\n\n"
                  "3. Payments: Transactions processed via SSLCommerz are subject to verification.\n\n"
                  "4. User Conduct: Respectful communication with home service providers is required.",
            );
          },
        ),

        // 4. About Us
        _buildSettingTile(
          icon: Icons.info_outline_rounded,
          title: "About Us",
          onTap: () {
            _showInfoDialog(
              "About Us",
              "Welcome to our on-demand Home Services application!\n\n"
                  "We provide trusted home salon, beauty, maintenance, AC servicing, and painting solutions across Bangladesh.\n\n"
                  "Version: 1.0.0\nDeveloped with Flutter & FastAPI.",
            );
          },
        ),

        const Gap(10),

        // 5. Logout
        _buildSettingTile(
          icon: Icons.logout_rounded,
          title: "Logout",
          iconColor: AppColor.danger,
          textColor: AppColor.danger,
          isDanger: true,
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }
}