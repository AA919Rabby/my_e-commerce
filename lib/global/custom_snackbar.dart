import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

void CustomSnackbar(
  BuildContext context, {
  required String title,
  required String message,
  Color backgroundColor = Colors.green,
  bool isError = false,
}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16.0),
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
