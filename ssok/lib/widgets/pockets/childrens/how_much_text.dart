import 'package:flutter/material.dart';

class HowMuchText extends StatefulWidget {
  const HowMuchText({
    Key? key,
    required this.title,
    this.subTitle,
    required this.imgUrl,
  }) : super(key: key);

  final String title;
  final String? subTitle;
  final String imgUrl;
  @override
  State<HowMuchText> createState() => _HowMuchTextState();
}

class _HowMuchTextState extends State<HowMuchText> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
          child: Stack(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.01),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.subTitle ?? "",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF818181),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.06),
        Image.asset(
          widget.imgUrl,
          height: screenHeight * 0.18,
        ),
        SizedBox(height: screenHeight * 0.05),
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.05),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "보유 포켓머니 : 500원",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        )
      ],
    );
  }
}
