import 'package:flutter/material.dart';

Widget contentBox(BuildContext context, Widget innerWidget, double height) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding:
        EdgeInsets.only(left: screenWidth * 0.15, right: screenWidth * 0.15),
    child: Container(
      width: screenWidth,
      height: screenHeight * height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: const Offset(1, 4),
          )
        ],
      ),
      child: innerWidget,
    ),
  );
}
