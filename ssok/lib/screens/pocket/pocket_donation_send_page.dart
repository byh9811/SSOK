import 'package:flutter/material.dart';
import 'package:ssok/widgets/pockets/childrens/enter_amount.dart';
import 'package:ssok/widgets/pockets/childrens/how_much_text.dart';

class PocketDonationSendPage extends StatefulWidget {
  const PocketDonationSendPage({super.key});

  @override
  State<PocketDonationSendPage> createState() => _PocketDonationSendPageState();
}

class _PocketDonationSendPageState extends State<PocketDonationSendPage> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "기부하기",
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
                title: "얼마를 기부할까요?",
                subTitle: "서울환경연합",
                imgUrl: 'assets/money.png',
                pocketSaving:0
              ),
              Divider(height: screenHeight * 0.025),
              EnterAmount(buttonTitle: "기부"),
            ],
          ),
        ),
      ),
    );
  }
}
