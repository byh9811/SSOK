import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:ssok/screens/mainpage/credit_card_page.dart';
import 'package:ssok/widgets/creditcards/childrens/my_credit_card.dart';
import 'package:ssok/screens/creditcard/credit_card_payment_page.dart';

class RegisteredCreditCard extends StatefulWidget {
  final CreditCard creditCard;
  const RegisteredCreditCard({required this.creditCard, Key? key})
      : super(key: key);

  @override
  State<RegisteredCreditCard> createState() => _RegisteredCreditCardState();
}

class _RegisteredCreditCardState extends State<RegisteredCreditCard> {
  late ShakeDetector detector;
  @override
  void initState() {
    super.initState();
    shake();
    if (!Navigator.of(context).canPop()) {
      detector.startListening();
    }
    // if(Navigator.of(context).canPop()){
    //   detector.stopListening();
    // }

    // detector = ShakeDetector.autoStart(
    //   onPhoneShake: () {
    //     if (Navigator.of(context).canPop()) {
    //       Navigator.of(context).pop();
    //     }

    //     Navigator.of(context).pushNamed('/creditcard/payment', arguments:{"ownerName":widget.creditCard.ownerName,"cardNum":widget.creditCard.cardNum});
    //   },
    //   minimumShakeCount: 3,
    //   shakeSlopTimeMS: 500,
    //   shakeCountResetTime: 3000,
    //   shakeThresholdGravity: 2.7,
    // );
  }

  void shake() {
    String cardNum = widget.creditCard.cardNum;
    String ownerName = widget.creditCard.ownerName;
    print(widget.creditCard.cardName);
    print(widget.creditCard.cardNum);
    detector = ShakeDetector.waitForStart(
      onPhoneShake: () {
        if (!Navigator.of(context).canPop()) {
          Navigator.of(context).pushNamed('/creditcard/payment',
              arguments: {"ownerName": ownerName, "cardNum": cardNum});
          // detector.stopListening();
        }
      },
      minimumShakeCount: 3,
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
        Text(
          widget.creditCard.cardName,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.09),
        Container(
          // color: Colors.amber,
          alignment: Alignment.center,
          child: MyCreditCard(
              vertical: true,
              ownerName: widget.creditCard.ownerName,
              cardNum: widget.creditCard.cardNum),
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
                    Navigator.of(context).pushNamed('/creditcard/payment',
                        arguments: {
                          "ownerName": widget.creditCard.ownerName,
                          "cardNum": widget.creditCard.cardNum
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00ADEF),
                  ),
                  child: Text("결제")),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/creditcard/history/list',
                        arguments: {
                          "ownerName": widget.creditCard.ownerName,
                          "cardNum": widget.creditCard.cardNum
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00ADEF),
                  ),
                  child: Text("내역")),
            ),
          ],
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pushNamed('/test');
        //   },
        //   child: Text("거래내역"),
        // ),
      ],
    );
  }
}
