import 'package:flutter/material.dart';
import 'package:ssok/widgets/pockets/childrens/enter_amount.dart';
import 'package:ssok/widgets/pockets/childrens/how_much_text.dart';

class PocketTransferPage extends StatefulWidget {
  const PocketTransferPage({super.key});

  @override
  State<PocketTransferPage> createState() => _PocketTransferPageState();
}

class _PocketTransferPageState extends State<PocketTransferPage> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "이체",
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // 원하는 색상으로 변경
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              HowMuchText(
                title: "내 통장에 얼마를 이체할까요?",
                imgUrl: 'assets/account.png',
              ),
              Divider(height: screenHeight * 0.025),
              EnterAmount(buttonTitle: "이체"),
            ],
          ),
        ),
      ),
    );
  }
}
