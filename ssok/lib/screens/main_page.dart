import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/mainpage/id_page.dart';
import 'package:ssok/screens/mainpage/business_card_page.dart';
import 'package:ssok/screens/mainpage/credit_card_page.dart';
import 'package:ssok/screens/mainpage/receipt_page.dart';
import 'package:ssok/screens/mainpage/pocket_page.dart';
import 'package:ssok/widgets/frequents/confirm.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 2; // 현재 보여주려는 index
  // bool _isCheckedChanges = false;
  final List<Widget> navPages = [
    // 각 위젯 페이지들
    IDPage(),
    BusinessCardPage(),
    PocketPage(),
    CreditCardPage(),
    ReceiptPage(),
  ];

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  ApiService apiService = ApiService();

  late String memberName = "회원";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.settings.arguments != null) {
          currentIndex = ModalRoute.of(context)!.settings.arguments as int;
        } else {
          currentIndex = 2; // 기본값 설정
        }

        setState(() {
          memberName = TokenManager().memberName ?? "회원";
        });

        print(currentIndex);
      });
    });
  }

  void userLogOut() async {
    print(TokenManager().loginId);
    print(TokenManager().accessToken);
    final response = await apiService.postRequest(
        "member-service/logout",
        {"memberId": TokenManager().loginId.toString()},
        TokenManager().accessToken);
    print(response.body);
    if (response.statusCode == 200) {
      TokenManager().logout();
      Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              confirmDialog(context, "로그아웃", "로그아웃 하시겠습니까?", () {
                userLogOut();
              }, height: 20);
              // final result = await showDialog<String>(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       title: const Text('로그아웃'),
              //       content: const Text('로그아웃 하시겠습니까?'),
              //       actions: [
              //         TextButton(
              //           onPressed: () {
              //             userLogOut();
              //           },
              //           child: const Text('네'),
              //         ),
              //         TextButton(
              //           onPressed: () {
              //             Navigator.pop(context, '아니오');
              //           },
              //           child: const Text('아니오'),
              //         ),
              //       ],
              //     );
              //   },
              // );
              // if (result == '네') {}
            },
            icon: Icon(Icons.logout),
            color: Color.fromARGB(255, 225, 225, 225),
            iconSize: 35,
          ),
        ],
        title: Image.asset(
          'assets/logo.png',
          height: 35,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              color: Color(0xFFEDEDED),
              height: 2.0,
            )),
      ),
      body: navPages.elementAt(currentIndex),
      bottomNavigationBar: SizedBox(
        height: 60.0,
        child: BottomNavigationBar(
          currentIndex: currentIndex, // 현재 보여주는 탭
          onTap: (newIndex) {
            setState(() {
              // 보여주려는 index 변경
              currentIndex = newIndex;
            });
          },
          // 아이콘 색상
          selectedItemColor: Color(0xFF00ADEF),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontSize: 13.5),
          unselectedLabelStyle: TextStyle(fontSize: 13.0),
          // label 숨기기
          // showSelectedLabels: true,
          // showUnselectedLabels: true,
          // 선택시 아이콘 움직이지 않기
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(),
                  child: Icon(
                    Icons.assignment_ind,
                    size: 23,
                  ),
                ),
                label: "신분증"), // index 0
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(),
                  child: Icon(
                    Icons.badge,
                    size: 24,
                  ),
                ),
                label: "명함"), // index 3
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(),
                  child: Icon(
                    Icons.monetization_on,
                    size: 24,
                  ),
                ),
                label: "포켓"), // index 1
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(),
                  child: Icon(
                    Icons.credit_card,
                    size: 24,
                  ),
                ),
                label: "카드"), // index 2
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(),
                  child: Icon(
                    Icons.receipt_long,
                    size: 24,
                  ),
                ),
                label: "영수증"), // index 4
          ],
        ),
      ),
    );
  }
}
