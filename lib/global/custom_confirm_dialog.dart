import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_text.dart';

class CustomConfirmDialog extends StatelessWidget {
  /// Custom widget at the top (optional)
  final Widget? headerWidget;

  /// Image path (Asset path or Network URL)
  final String? imagePath;

  /// IconData (e.g. Icons.check_circle_outline)
  final IconData? icon;
  final Color? iconColor;

  /// Only one Title
  final String title;

  /// Put your CustomButton or any widget here
  final Widget? child;

  const CustomConfirmDialog({
    super.key,
    this.headerWidget,
    this.imagePath,
    this.icon,
    this.iconColor,
    required this.title,
    this.child,
  });

  /// Show CustomConfirmDialog
  ///
  /// barrierDismissible is false by default.
  /// This means:
  /// - Tapping outside cannot close the dialog
  /// - Back button cannot close the dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    Widget? headerWidget,
    String? imagePath,
    IconData? icon,
    Color? iconColor,
    Widget? child,
  }) {
    return showDialog<T>(
      context: context,

      // Prevent closing by tapping outside
      barrierDismissible: false,

      builder: (context) {
        return CustomConfirmDialog(
          headerWidget: headerWidget,
          imagePath: imagePath,
          icon: icon,
          iconColor: iconColor,
          title: title,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent Android back button from closing
      canPop: false,

      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Glow Top Right
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.drawerGradient1.withOpacity(0.35),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.drawerGradient1.withOpacity(0.3),
                      blurRadius: 80,
                    ),
                  ],
                ),
              ),
            ),

            // Ambient Glow Bottom Left
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary.withOpacity(0.35),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.3),
                      blurRadius: 80,
                    ),
                  ],
                ),
              ),
            ),

            // Glassmorphic Card
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 16,
                  sigmaY: 16,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.14),
                        Colors.white.withOpacity(0.04),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.18),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Header
                      _buildTopHeader(),

                      if (_hasHeader()) const Gap(16),

                      // Single Title
                      CustomText(
                        text: title,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        color: AppColor.text,
                      ),

                      // Action Child
                      if (child != null) ...[
                        const Gap(24),
                        child!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasHeader() {
    return headerWidget != null ||
        imagePath != null ||
        icon != null;
  }

  Widget _buildTopHeader() {
    if (headerWidget != null) {
      return headerWidget!;
    }

    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('http')) {
        return Image.network(
          imagePath!,
          height: 64,
          width: 64,
          fit: BoxFit.contain,
        );
      }

      return Image.asset(
        imagePath!,
        height: 64,
        width: 64,
        fit: BoxFit.contain,
      );
    }

    if (icon != null) {
      return Center(
        child: Icon(
          icon,
          size: 70,
          color: iconColor ?? AppColor.primary,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}