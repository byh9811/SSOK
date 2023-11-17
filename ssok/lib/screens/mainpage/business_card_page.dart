import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/loading/basic_loading_page.dart';
import 'package:ssok/screens/loading/transfer_loading_page.dart';
import 'package:ssok/widgets/businesscards/not_registered_business_card.dart';
import 'package:ssok/widgets/businesscards/registered_business_card.dart';

class BusinessCardPage extends StatefulWidget {
  const BusinessCardPage({super.key});

  @override
  State<BusinessCardPage> createState() => _BusinessCardPageState();
}

class _BusinessCardPageState extends State<BusinessCardPage> {
  ApiService apiService = ApiService();
  bool isExistNameCard = false;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isBussinessCard();
  }

  void isBussinessCard() async {
    final response = await apiService.getRequest(
        "namecard-service/exist", TokenManager().accessToken);
    final json = jsonDecode(response.body);
    print("명함 보유 여부");
    print(json);
    if (response.statusCode == 200) {
      setState(() {
        isExistNameCard = json["response"];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading // isLoading 상태에 따라 다른 화면 표시
        ? BasicLoadingPage()
        : isExistNameCard
            ? RegisteredBusinessCard()
            : NotRegisteredBusinessCard();
  }
}
