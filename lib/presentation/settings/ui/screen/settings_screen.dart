import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_text.dart';
import '../widget/settings_list.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.text,
      appBar: AppBar(
        backgroundColor: AppColor.drawerGradient1,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const CustomText(
          text: "Settings",
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColor.text,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: const SettingsList(),
        ),
      ),
    );
  }
}