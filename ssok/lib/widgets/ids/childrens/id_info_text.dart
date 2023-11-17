import 'package:flutter/material.dart';

Widget idInfoText(context, String title, String content) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 12),
      ),
      Padding(
        padding: EdgeInsets.only(left: screenWidth * 0.01, top: 4.0),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    ],
  );
}
