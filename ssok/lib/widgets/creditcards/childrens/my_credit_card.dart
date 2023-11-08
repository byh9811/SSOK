import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'dart:math' as math;

class MyCreditCard extends StatelessWidget {
  const MyCreditCard({
    Key? key,
    required this.vertical,
  }) : super(key: key);
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: vertical ? math.pi / 2 : 0,
      child: CreditCardUi(
        cardHolderFullName: '홍길동',
        cardNumber: '4123456781234567',
        validFrom: '01/23',
        validThru: '01/28',
        topLeftColor: Colors.blue,
        doesSupportNfc: true,
        placeNfcIconAtTheEnd: true,
        cardType: CardType.other,
        creditCardType: CreditCardType.none,
        cardProviderLogo: FlutterLogo(),
        cardProviderLogoPosition: CardProviderLogoPosition.right,
      ),
    );
  }
}
