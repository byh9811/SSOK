import 'package:flutter/material.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class PocketDonationPage extends StatefulWidget {
  const PocketDonationPage({super.key});

  @override
  State<PocketDonationPage> createState() => _PocketDonationPageState();
}

class _PocketDonationPageState extends State<PocketDonationPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "기부",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
            OutgoingDonationList(),
            SizedBox(height: screenHeight * 0.06),
            Divider(height: 1),
            SizedBox(height: screenHeight * 0.01),
            EndedDonationList(),
          ],
        ),
      ),
    );
  }
}

class OutgoingDonationList extends StatefulWidget {
  const OutgoingDonationList({super.key});

  @override
  State<OutgoingDonationList> createState() => _OutgoingDonationListState();
}

class _OutgoingDonationListState extends State<OutgoingDonationList> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 10.0),
          child: Text(
            "진행중인 기부목록",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              border: Border.all(
                color: Color(0xFF787878), // 테두리 색상
                width: 0.5, // 테두리 두께
              ),
            ),
            child: Column(children: [
              Container(
                height: screenHeight * 0.2,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.01),
                child: Row(
                  children: [
                    Text(
                      "2023 3분기",
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "서울환경연합",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF818181),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: screenWidth * 0.04, top: screenHeight * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.04),
                      child: Text(
                        "현재 누적 기부금",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      " 400,000원",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        MainButton(
          title: "기부하기",
          onPressed: () {
            Navigator.of(context).pushNamed('/pocket/donation/send');
          },
        ),
      ],
    );
  }
}

class EndedDonationList extends StatefulWidget {
  const EndedDonationList({super.key});

  @override
  State<EndedDonationList> createState() => _EndedDonationListState();
}

class _EndedDonationListState extends State<EndedDonationList> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 10.0),
          child: Text(
            "종료된 기부목록",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              border: Border.all(
                color: Color(0xFF787878), // 테두리 색상
                width: 0.5, // 테두리 두께
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
      ],
    );
  }
}
