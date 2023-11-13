import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/ids/childrens/id_info_text.dart';

import '../../http/http.dart';
import '../../http/token_manager.dart';

class IdDetailPage extends StatefulWidget {
  const IdDetailPage({super.key});

  @override
  State<IdDetailPage> createState() => _IdDetailPageState();
}

class _IdDetailPageState extends State<IdDetailPage> {

  ApiService apiService = ApiService();
  late String registrationCardName = "";
  late String registrationCardPersonalNumber = "";
  late String registrationCardAddress = "";
  late String registrationCardIssueDate = "";
  late String registrationCardAuthority = "";
  late String registrationCardImage = "";

  @override
  void initState() {
    super.initState();
    getRegCard();
  }

  void getRegCard() async {
    final response = await apiService.getRequest(
        "idcard-service/registration", TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final tempRes = jsonData['response'];

      setState(() {
        registrationCardName = tempRes['registrationCardName'];
        registrationCardPersonalNumber = tempRes['registrationCardPersonalNumber'];
        registrationCardAddress = tempRes['registrationCardAddress'];
        registrationCardIssueDate = tempRes['registrationCardIssueDate'];
        registrationCardAuthority = tempRes['registrationCardAuthority'];
        registrationCardImage = tempRes['registrationCardImage'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "주민등록증",
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenHeight * 0.21,
            width: screenWidth * 0.7,
            child: Image.network(registrationCardImage, fit: BoxFit.fill),
          ),
          SizedBox(height: screenHeight * 0.05),
          contentBox(
            context,
            Column(
              children: [
                Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/registration_card_color.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 40,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight * 0.4,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.03, top: screenHeight * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          idInfoText(context, "이름", registrationCardName),
                          SizedBox(height: screenHeight * 0.01),
                          idInfoText(context, "주민번호", registrationCardPersonalNumber),
                          SizedBox(height: screenHeight * 0.01),
                          idInfoText(context, "주소", registrationCardAddress),
                          SizedBox(height: screenHeight * 0.01),
                          idInfoText(context, "발급일자", registrationCardIssueDate),
                          SizedBox(height: screenHeight * 0.01),
                          idInfoText(context, "인증기관", registrationCardAuthority),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            0.5,
          ),
        ],
      ),
    );
  }
}
