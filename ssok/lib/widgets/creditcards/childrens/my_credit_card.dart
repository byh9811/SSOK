import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'dart:math' as math;

class MyCreditCard extends StatelessWidget {
  const MyCreditCard({
    Key? key,
    required this.vertical,
    this.cardNum,
    this.ownerName,
  }) : super(key: key);
  final bool vertical;
  final String? cardNum;
  final String? ownerName;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: vertical ? math.pi / 2 : 0,
      child: CreditCardUi(
        cardHolderFullName: '$ownerName',
        cardNumber: '$cardNum',
        validFrom: '01/23',
        validThru: '01/28',
        topLeftColor: Colors.blue,
        doesSupportNfc: true,
        placeNfcIconAtTheEnd: true,
        cardType: CardType.other,
        creditCardType: CreditCardType.none,
        cardProviderLogo: Image.asset("assets/logo.png", width: 60),
        cardProviderLogoPosition: CardProviderLogoPosition.right,
      ),
    );
  }
}
