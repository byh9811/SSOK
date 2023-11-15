import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/creditcards/childrens/my_credit_card.dart';
import 'package:ssok/widgets/frequents/main_button.dart';
import 'package:ssok/widgets/pockets/childrens/my_account.dart';

class PocketAccountCreatePage extends StatefulWidget {
  const PocketAccountCreatePage({super.key});

  @override
  State<PocketAccountCreatePage> createState() =>
      _PocketAccountCreatePageState();
}

class CreditCard {
  late String cardName;
  late String ownerName;
  late String cardNum;
  CreditCard(this.cardName, this.ownerName, this.cardNum);
}


class _PocketAccountCreatePageState extends State<PocketAccountCreatePage> {
  double yOffset = 0.0; // 초기 Y 위치
  double speed = 0.3; // 애니메이션 속도
  late CreditCard creditCard= CreditCard("cardName", "ownerName", "cardNum");
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    startAnimation();
    checkCreditCard();
  }

  void checkCreditCard() async {
    final response = await apiService.getRequest(
        'receipt-service/card', TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      print("카드 연동 여부");
      print(jsonData);
      setState(() {
        creditCard = CreditCard(jsonData['response']['cardName'],jsonData['response']['ownerName'], jsonData['response']['cardNum']);
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  void startAnimation() {
    Future.delayed(Duration(milliseconds: 16)).then((_) {
      setState(() {
        yOffset += speed;
        if (yOffset >= 10.0) {
          yOffset = -10.0;
        }
        startAnimation();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.06,
            ),
            introText(),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            selectText("계좌 · 카드","가 연동되었습니다."),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Align(alignment: Alignment.centerLeft, child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.11),
              child: Text("계좌 정보",style: TextStyle(fontSize: 20)),
            )),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            MyAccount(),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Align(alignment: Alignment.centerLeft, child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.11),
              child: Text("카드 정보",style: TextStyle(fontSize: 20)),
            )),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            MyCreditCard(
              vertical: false,
              ownerName: creditCard.ownerName,
              cardNum: creditCard.cardNum),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
              height: 90,
              transform: Matrix4.translationValues(0, yOffset, 0), // Y 위치 변경
              child: Image.asset(
                'assets/point.png',
                height: 90,
              ),
            ),
            MainButton(title: "포켓머니 생성하기", color: "0xFF00ADEF", onPressed: () {
            Navigator.of(context).pushReplacementNamed('/pocket/pocket/create'); //포켓페이지로 이동해야댐
            })
          ],
        ),
      ),
    );
  } 

  Widget introText() {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "자산",
                style: TextStyle(
                  fontSize: 35,
                  color: Color(0xFF00ADEF),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "이 연동되었습니다.",
                  style: TextStyle(
                    color: Color(0xFF00496F),
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget selectText(String blue, String black) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.1),
      child: Row(
        children: [
          Text(
            blue,
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF00ADEF),
            ),
          ),
          Text(
            black,
            style: TextStyle(
              color: Color(0xFF00496F),
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
  Widget selectText1() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.1),
      child: Row(
        children: [
          Text(
            "주 계좌",
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF00ADEF),
            ),
          ),
          Text(
            "를 선택하세요.",
            style: TextStyle(
              color: Color(0xFF00496F),
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
