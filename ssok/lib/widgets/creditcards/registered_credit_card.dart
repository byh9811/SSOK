import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:ssok/screens/mainpage/credit_card_page.dart';
import 'package:ssok/widgets/creditcards/childrens/my_credit_card.dart';
import 'package:ssok/screens/creditcard/credit_card_payment_page.dart';

class RegisteredCreditCard extends StatefulWidget {
  
  final CreditCard creditCard;
  const RegisteredCreditCard({required this.creditCard, Key? key}) : super(key: key);

  @override
  State<RegisteredCreditCard> createState() => _RegisteredCreditCardState();
}

class _RegisteredCreditCardState extends State<RegisteredCreditCard> {
  late ShakeDetector detector;
  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).pushNamed('/creditcard/payment');
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.15),
        Text(widget.creditCard.cardName),
        SizedBox(height: screenHeight * 0.1),
        Container(
          color: Colors.amber,
          alignment: Alignment.center,
          child: MyCreditCard(
            vertical: true,
            ownerName: widget.creditCard.ownerName,
            cardNum: widget.creditCard.cardNum
          ),
        ),
        SizedBox(height: screenHeight * 0.12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: ElevatedButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    Navigator.of(context).pushNamed('/creditcard/payment');
                  },
                  child: Text("결제")),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/test');
                  },
                  child: Text("내역")),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pushNamed('/creditcard/history/list');
          }, 
          child: Text("거래내역"),
        ),
      ],
    );
  }
}
