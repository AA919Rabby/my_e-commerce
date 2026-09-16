import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

void CustomSnackbar(
    BuildContext context, {
      required String title,
      required String message,
      Color backgroundColor = Colors.green, // Default color matching your image
    }) {
  final snackBar = SnackBar(
    // 1. Set behavior to floating
    behavior: SnackBarBehavior.floating,
    // 2. Add margins to detach it from the bottom and screen edges
    margin: const EdgeInsets.all(16.0),
    backgroundColor: backgroundColor,
    // 3. Add rounded corners
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    // 4. Build the custom content with a Title and Message
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const Gap(4),
        Text(
          message,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
  );

  // Clear any existing snackbars before showing the new one
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}