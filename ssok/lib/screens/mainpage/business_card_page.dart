import 'package:flutter/material.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';

class BusinessCardPage extends StatefulWidget {
  const BusinessCardPage({Key? key}) : super(key: key);

  @override
  State<BusinessCardPage> createState() => _IdPageState();
}

class _IdPageState extends State<BusinessCardPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(children: [
        SizedBox(height: screenHeight * 0.1),
        introText(),
        SizedBox(height: screenHeight * 0.08),
        contentBox(
          context,
          Column(
            children: [
              Expanded(
                child: Text(
                  "등록된 명함이 없습니다",
                  style: TextStyle(color: Color(0xFF989898)),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.06,
                width: screenWidth * 0.7,
                child: registerButton(
                  onPressed: () {},
                ),
              )
            ],
          ),
          0.27,
        ),
      ]),
    );
  }

  Widget introText() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.08),
          child: Row(
            children: [
              Text(
                "명함 교환",
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF00ADEF),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(
                  "을",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.1),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "손쉽게 할 수 있어요",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
