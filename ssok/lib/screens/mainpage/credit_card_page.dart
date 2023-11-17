import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/loading/basic_loading_page.dart';
import 'package:ssok/widgets/creditcards/not_registered_credit_card.dart';
import 'package:ssok/widgets/creditcards/registered_credit_card.dart';

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  State<CreditCardPage> createState() => _IdPageState();
}

class CreditCard {
  late String cardName;
  late String ownerName;
  late String cardNum;
  CreditCard(this.cardName, this.ownerName, this.cardNum);
}

class _IdPageState extends State<CreditCardPage> {
  ApiService apiService = ApiService();
  bool isCreditCardRegiste = false;
  late CreditCard creditCard;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCreditCard();
  }

  void checkCreditCard() async {
    final response = await apiService.getRequest(
        'receipt-service/card', TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      print("카드 연동 여부");
      print(jsonData);
      setState(() {
        isCreditCardRegiste = true;
        creditCard = CreditCard(jsonData['response']['cardName'],
            jsonData['response']['ownerName'], jsonData['response']['cardNum']);
        isLoading = false;
      });
    } else if (response.statusCode == 500) {
      setState(() {
        isLoading = false;
      });
      print(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? BasicLoadingPage()
        : isCreditCardRegiste
            ? RegisteredCreditCard(creditCard: creditCard)
            : NotRegisteredCreditCard();
  }
}
