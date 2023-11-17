import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class CreditCardCreatePage extends StatefulWidget {
  const CreditCardCreatePage({super.key});

  @override
  State<CreditCardCreatePage> createState() => _CreditCardCreatePage();
}

class _CreditCardCreatePage extends State<CreditCardCreatePage> {
  ApiService apiService = ApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeCard();
  }

  void makeCard() async {
    final response = await apiService.postRequest(
        'receipt-service/card', {}, TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      print("카드 연동 여부");
      print(jsonData);
      setState(() {});
    } else if (response.statusCode == 500) {
      print(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.2),
            completeText(context),
            SizedBox(height: screenHeight * 0.1),
            MainButton(
                title: "메인으로",
                color: "0xFF00ADEF",
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/main", (route) => false,
                      arguments: 3);
                  // Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

Widget completeText(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "카드생성",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500,
          color: Color(0xFF00ADEF),
        ),
      ),
      Text(
        "이",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(
          "완료",
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFF00496F),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(
          "되었습니다.",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}
