import 'package:flutter/material.dart';
// import 'package:ssok/widgets/businesscards/not_registered_business_card.dart';
import 'package:ssok/widgets/businesscards/registered_business_card.dart';

class BusinessCardPage extends StatefulWidget {
  const BusinessCardPage({super.key});

  @override
  State<BusinessCardPage> createState() => _BusinessCardPageState();
}

class _BusinessCardPageState extends State<BusinessCardPage> {
  @override
  Widget build(BuildContext context) {
    // return NotRegisteredBusinessCard();
    return RegisteredBusinessCard();
  }
}
