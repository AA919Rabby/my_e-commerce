import 'package:flutter/material.dart';
import 'package:mye_commerce/core/theme/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColor.secondaryText,
        child: Column(
          children: [

          ],
        ),
      )),
    );
  }
}
