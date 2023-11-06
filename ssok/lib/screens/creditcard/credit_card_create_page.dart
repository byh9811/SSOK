import 'package:flutter/material.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class CreditCardCreatePage extends StatelessWidget {
  const CreditCardCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.2),
            completeText(context),
            SizedBox(height: screenHeight * 0.1),
            MainButton(
                title: "메인으로",
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  Widget completeText(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "카드생성",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Color(0xFF00ADEF),
          ),
        ),
        Text(
          "이",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            "완료",
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFF00496F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            "되었습니다.",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
