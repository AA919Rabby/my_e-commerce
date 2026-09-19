import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

void CustomSnackbar(
    BuildContext context, {
      required String title,
      required String message,
      Color backgroundColor = Colors.green,
      bool isError = false,
    }) {
  // 1. Get screen constraints to push the snackbar from the bottom to the top
  final double screenHeight = MediaQuery.sizeOf(context).height;
  final double topPadding = MediaQuery.paddingOf(context).top;
  const double estimatedHeight = 100.0;

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    // 2. This exact margin structure forces it to render at the top
    margin: EdgeInsets.only(
      top: topPadding + 16.0,
      left: 16.0,
      right: 16.0,
      bottom: screenHeight - topPadding - estimatedHeight,
    ),
    // 3. Allows natural up-swipe dismissal since it is at the top
    dismissDirection: DismissDirection.up,
    backgroundColor: isError ? Colors.red : backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
          style: const TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
