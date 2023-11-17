import 'package:flutter/material.dart';
import 'package:ssok/widgets/receipts/receipt_history_list.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({Key? key}) : super(key: key);

  @override
  State<ReceiptPage> createState() => _IdPageState();
}

class _IdPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.02),
        introText(),
        ReceiptHistoryList(),
      ],
    );
  }

  Widget introText() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.07),
          child: Row(
            children: [
              Text(
                "전자영수증",
                style: TextStyle(
                  fontSize: 23,
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
          padding: EdgeInsets.only(top: 2.0, left: screenWidth * 0.08),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "확인할 수 있어요",
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
      ],
    );
  }
}
