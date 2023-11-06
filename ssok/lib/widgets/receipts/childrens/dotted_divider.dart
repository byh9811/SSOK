import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Color(0xFFC2C2C2),
      strokeWidth: 2,
      customPath: (size) {
        return Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0);
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(),
      ),
    );
  }
}
