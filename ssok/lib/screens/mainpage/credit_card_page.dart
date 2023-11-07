import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/widgets/creditcards/not_registered_credit_card.dart';
import 'package:ssok/widgets/creditcards/registered_credit_card.dart';

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  State<CreditCardPage> createState() => _IdPageState();
}

class _IdPageState extends State<CreditCardPage> {
  @override
  Widget build(BuildContext context) {
    // return NotRegisteredCreditCard();
    return RegisteredCreditCard();
  }
}
