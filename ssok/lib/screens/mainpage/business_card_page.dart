import 'package:flutter/material.dart';
import 'package:ssok/widgets/businesscards/not_registered_business_card.dart';
import 'package:ssok/widgets/businesscards/registered_business_card.dart';

class BusinessCardPage extends StatefulWidget {
  const BusinessCardPage({super.key});

  @override
  State<BusinessCardPage> createState() => _BusinessCardPageState();
}

class _BusinessCardPageState extends State<BusinessCardPage> {
  bool isBusinessCardRegiste = false;
  @override
  Widget build(BuildContext context) {
    if (isBusinessCardRegiste) {
      return RegisteredBusinessCard();
    }
    return NotRegisteredBusinessCard();
  }
}
