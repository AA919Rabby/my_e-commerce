import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const HomeSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColor.drawerGradient1.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color:Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: AppColor.text),
            cursorColor: AppColor.primary,
            decoration: InputDecoration(
              hintText: "Search products...",
              hintStyle: TextStyle(
                color: AppColor.secondaryText.withOpacity(0.6),
                fontSize: 14,
              ),
              suffixIcon: Icon(Icons.mic,color: AppColor.secondaryText,
                size: 22,),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColor.secondaryText,
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}