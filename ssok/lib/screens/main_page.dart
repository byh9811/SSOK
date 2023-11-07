import 'package:flutter/material.dart';
import 'package:ssok/screens/mainpage/id_page.dart';
import 'package:ssok/screens/mainpage/business_card_page.dart';
import 'package:ssok/screens/mainpage/credit_card_page.dart';
import 'package:ssok/screens/mainpage/receipt_page.dart';
import 'package:ssok/screens/mainpage/pocket_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0; // 현재 보여주려는 index

  final List<Widget> navPages = [
    // 각 위젯 페이지들
    IDPage(),
    BusinessCardPage(),
    CreditCardPage(),
    ReceiptPage(),
    PocketPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Color(0xFF676767),
              size: 30.0,
            ),
            onPressed: () {},
          )
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
                label: "명함"), // index 1
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
                label: "영수증"), // index 3
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(),
                  child: Icon(
                    Icons.monetization_on,
                    size: 24,
                  ),
                ),
                label: "포켓"), // index 4
          ],
        ),
      ),
    );
  }
}
