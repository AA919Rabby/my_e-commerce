

import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;
  final double? indent;
  final double? endIndent;
  final double? thickness;
  final double? height;
  const CustomDivider({super.key,
    this.color,
    this.indent,
    this.endIndent,
    this.thickness,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      indent: indent,endIndent: endIndent,thickness: thickness ?? height,
    );
  }
}