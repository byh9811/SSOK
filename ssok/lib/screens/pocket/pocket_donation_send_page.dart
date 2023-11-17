import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    var numberFormat = NumberFormat('###,###,###,###');
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    print(args);
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
              SizedBox(height: screenHeight * 0.04),
              Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: Stack(
                    children: [
                      Text(
                        args["donateTitle"],
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Image.network(
                  args["donateImage"], // 이미지 링크 필드로 변경
                  fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 조절
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, top:screenHeight*0.005),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                      "현재 누적 기부금 : ${numberFormat.format(args["donateTotalDonation"])}원",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, top:screenHeight*0.005),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:
                      Text(
                        "현재 누적 기부자 : ${numberFormat.format(args["donateTotalDonator"])}명",
                        style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 1),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, top:screenHeight*0.005),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:
                      Text(
                        "나의 누적 기부 금액 : ${numberFormat.format(args["memberTotalDonateAmt"])}원",
                        style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),                   
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, top:screenHeight*0.005),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "보유 포켓머니 : ${numberFormat.format(args["pocketSaving"])}원",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
              // Divider(height: screenHeight * 0.025),
              EnterAmount(buttonTitle: "기부",donateSeq: args["donateSeq"]),
            ],
          ),
        ),
      ),
    );
  }
}
