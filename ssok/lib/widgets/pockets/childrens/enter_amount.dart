import 'package:flutter/material.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class EnterAmount extends StatefulWidget {
  const EnterAmount({
    Key? key,
    required this.buttonTitle,
  }) : super(key: key);
  final String buttonTitle;
  @override
  State<EnterAmount> createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.1),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  onChanged: (text) {}, // 텍스트 변경시 실행되는 함수
                  onSubmitted: (text) {}, // Enter를 누를 때 실행되는 함수
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding: EdgeInsets.only(top: screenHeight * 0.018),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.04, top: screenHeight * 0.02),
                child: Text(
                  "원",
                  style: TextStyle(fontSize: 22),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.08),
        MainButton(
          title: widget.buttonTitle,
          onPressed: () {},
        )
      ],
    );
  }
}
