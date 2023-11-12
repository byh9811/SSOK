import 'package:flutter/material.dart';
import 'package:ssok/widgets/frequents/main_button.dart';
import 'package:ssok/widgets/pockets/childrens/my_account.dart';

class PocketAccountCreatePage extends StatefulWidget {
  const PocketAccountCreatePage({super.key});

  @override
  State<PocketAccountCreatePage> createState() =>
      _PocketAccountCreatePageState();
}

class _PocketAccountCreatePageState extends State<PocketAccountCreatePage> {
  double yOffset = 0.0; // 초기 Y 위치
  double speed = 0.3; // 애니메이션 속도

  @override
  void initState() {
    super.initState();
    startAnimation();
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
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            introText(),
            SizedBox(
              height: screenHeight * 0.05,
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
            selectText(),
            MyAccount(),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            MainButton(title: "포켓머니 생성하기", onPressed: () {
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
                "계좌",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF00ADEF),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "가",
                  style: TextStyle(
                    color: Color(0xFF00496F),
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "생성되었습니다.",
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFF00496F),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectText() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.1),
      child: Row(
        children: [
          Text(
            "생성 계좌",
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF00ADEF),
            ),
          ),
          Text(
            "가 연동되었습니다.",
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
