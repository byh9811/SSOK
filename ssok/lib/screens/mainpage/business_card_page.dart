import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isExistNameCard
        ? RegisteredBusinessCard()
        : NotRegisteredBusinessCard();
  }
}
