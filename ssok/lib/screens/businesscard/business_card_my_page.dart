import 'package:flutter/material.dart';
import 'package:ssok/widgets/businesscards/childrens/content_by_card.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class BusinessCardMyPage extends StatelessWidget {
  const BusinessCardMyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> businessCardInfo = {
      'namecardName': '홍길동',
      'namecardJob': 'Android Developer',
      'namecardCompany': 'Dev Team',
      'namecardAddress': '경기도 성남시 분당구 ...',
      'namecardPhone': '010-1111-2222',
      'namecardTel': '010-1111-2222',
      'namecardFax': '050-000-2222',
      'namecardEmail': 'i0364842@naver.com',
      'namecardWebsite': 'samsung.com',
    };
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "내 명함",
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 9 / 5,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Container(
                    color: Colors.amber,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: updateButton("수정", () {}, context),
              ),
              SizedBox(height: screenHeight * 0.015),
              ContentByCard(
                title: "이름",
                content: businessCardInfo['namecardName'] ?? "",
              ),
              ContentByCard(
                title: "직책(회사)",
                content: (businessCardInfo['namecardJob'] ?? "") +
                    " / " +
                    (businessCardInfo['namecardCompany'] ?? ""),
              ),
              ContentByCard(
                title: "주소",
                content: businessCardInfo['namecardAddress'] ?? "",
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(height: screenHeight * 0.02),
              ContentByCard(
                title: "휴대폰",
                content: businessCardInfo['namecardPhone'] ?? "",
              ),
              ContentByCard(
                title: "회사번호",
                content: businessCardInfo['namecardTel'] ?? "",
              ),
              ContentByCard(
                title: "FAX",
                content: businessCardInfo['namecardFax'] ?? "",
              ),
              ContentByCard(
                title: "이메일",
                content: businessCardInfo['namecardEmail'] ?? "",
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(height: screenHeight * 0.02),
              ContentByCard(
                title: "홈페이지",
                content: businessCardInfo['namecardWebsite'] ?? "",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget updateButton(String text, Function() onPressed, context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          screenWidth * 0.25,
          screenHeight * 0.05,
        ),
        backgroundColor: Color(0xFF00ADEF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
