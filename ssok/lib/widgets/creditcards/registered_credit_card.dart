import 'package:flutter/material.dart';

import 'package:u_credit_card/u_credit_card.dart';

class RegisteredCreditCard extends StatefulWidget {
  const RegisteredCreditCard({super.key});

  @override
  State<RegisteredCreditCard> createState() => _RegisteredCreditCardState();
}

class _RegisteredCreditCardState extends State<RegisteredCreditCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
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
        ),
      ],
    );
  }
}
