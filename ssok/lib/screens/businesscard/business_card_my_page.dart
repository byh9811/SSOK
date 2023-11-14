import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/businesscards/childrens/content_by_card.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class BusinessCardMyPage extends StatefulWidget {
  const BusinessCardMyPage({super.key});
  @override
  State<BusinessCardMyPage> createState() => _BusinessCardMyPage();
}

class _BusinessCardMyPage extends State<BusinessCardMyPage> {
  ApiService apiService = ApiService();
  late int args;
  late Map<String, dynamic> mycardInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      // ModalRoute.of(context)!.settings.arguments를 통해 데이터를 읽어옵니다.
      args = ModalRoute.of(context)!.settings.arguments as int;
      // 읽어온 데이터를 출력하거나 다른 초기화 작업을 수행할 수 있습니다.
      getMyNameCardInfo(args);
    });
  }

  void getMyNameCardInfo(int nameCardSeq) async {
    print(nameCardSeq);
    final response = await apiService.getRequest(
        "namecard-service/my/${nameCardSeq}", TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      print("getMyNameCardInfo");
      print(jsonData["response"]);

      setState(() {
        mycardInfo = jsonData["response"];
        print(mycardInfo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int;

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
                  child: Image.network(mycardInfo["namecardImage"]),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: updateButton("명함 갱신", () {}, context),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: screenWidth * 0.008, top: screenHeight * 0.006),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("/businesscard/myhistory",
                          arguments: args);
                    },
                    child: SizedBox(
                      width: screenWidth * 0.2,
                      child: Row(
                        children: [
                          Icon(Icons.timeline),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              "타임라인",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              if (mycardInfo["namecardName"] != "")
                ContentByCard(
                  title: "이름",
                  content: mycardInfo["namecardName"],
                ),
              if (mycardInfo['namecardCompany'] != "")
                ContentByCard(
                  title: "회사 / 직책",
                  content: (mycardInfo['namecardCompany']) +
                      " / " +
                      (mycardInfo['namecardJob'] ?? ""),
                ),
              if (mycardInfo['namecardAddress'] != "")
                ContentByCard(
                  title: "주소",
                  content: mycardInfo['namecardAddress'],
                ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(height: screenHeight * 0.02),
              if (mycardInfo['namecardPhone'] != "")
                ContentByCard(
                  title: "휴대폰",
                  content: mycardInfo['namecardPhone'],
                ),
              if (mycardInfo['namecardTel'] != "")
                ContentByCard(
                  title: "회사번호",
                  content: mycardInfo['namecardTel'],
                ),
              if (mycardInfo['namecardFax'] != "")
                ContentByCard(
                  title: "FAX",
                  content: mycardInfo['namecardFax'],
                ),
              if (mycardInfo['namecardEmail'] != "")
                ContentByCard(
                  title: "이메일",
                  content: mycardInfo['namecardEmail'],
                ),
              if (mycardInfo['namecardWebsite'] != "")
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
              if (mycardInfo['namecardWebsite'] != "")
                SizedBox(height: screenHeight * 0.02),
              if (mycardInfo['namecardWebsite'] != "")
                ContentByCard(
                  title: "홈페이지",
                  content: mycardInfo['namecardWebsite'],
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
        backgroundColor: Color.fromARGB(255, 72, 96, 253),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
