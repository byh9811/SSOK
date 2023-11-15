import 'package:flutter/material.dart';

class HowMuchText extends StatefulWidget {
  const HowMuchText({
    Key? key,
    required this.title,
    this.subTitle,
    required this.imgUrl,
    required this.pocketSaving,
    required this.urlType,
  }) : super(key: key);

  final String title;
  final String? subTitle;
  final String imgUrl;
  final int pocketSaving;
  final String urlType;
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
                  fontSize: 27,
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
        SizedBox(height: screenHeight * 0.03),
        widget.urlType == "network"
            ? Image.network(
                widget.imgUrl, // 이미지 링크 필드로 변경
                fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 조절
              )
            : Image.asset(
                widget.imgUrl,
                height: screenHeight * 0.18,
              ),
        SizedBox(height: screenHeight * 0.05),
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.05),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "보유 포켓머니 : ${widget.pocketSaving}원",
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
