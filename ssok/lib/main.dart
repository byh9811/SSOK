import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0; // 현재 보여주려는 index

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
          height: 32,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              color: Color(0xFFEDEDED),
              height: 1.0,
            )),
      ),
      body: Column(children: [
        Box(context, Text("주민등록증")),
        Box(context, Text("운전면허증")),
      ]),
      bottomNavigationBar: SizedBox(
        height: screenHeight * 0.07,
        child: BottomNavigationBar(
          currentIndex: currentIndex, // 현재 보여주는 탭
          onTap: (newIndex) {
            print("selected newIndex : $newIndex");
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
                  padding: const EdgeInsets.only(bottom: 2.5),
                  child: Icon(Icons.assignment_ind),
                ),
                label: "신분증"), // index 0
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 2.5),
                  child: Icon(Icons.badge),
                ),
                label: "명함"), // index 1
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Icon(Icons.credit_card),
                ),
                label: "카드"), // index 2
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Icon(Icons.receipt_long),
                ),
                label: "영수증"), // index 3
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Icon(Icons.monetization_on),
                ),
                label: "포켓"), // index 4
          ],
        ),
      ),
    );
  }
}

Widget Box(BuildContext context, Widget innerWidget) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding:
        EdgeInsets.only(left: screenWidth * 0.15, right: screenWidth * 0.15),
    child: Container(
        width: screenWidth,
        height: screenHeight * 0.23,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: const Offset(1, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: innerWidget,
            ),
            SizedBox(
              height: screenHeight * 0.08,
              width: screenWidth * 0.7,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0), // 좌측 위 모서리
                      bottomRight: Radius.circular(10.0), // 우측 위 모서리
                    ),
                  ),
                ),
                child: Text("등록"),
              ),
            )
          ],
        )),
  );
}
