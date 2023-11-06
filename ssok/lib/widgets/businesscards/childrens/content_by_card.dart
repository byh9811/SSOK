import 'package:flutter/material.dart';

class ContentByCard extends StatelessWidget {
  const ContentByCard({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
          left: screenWidth * 0.02, bottom: screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF9B9999),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.008, left: screenWidth * 0.01),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
