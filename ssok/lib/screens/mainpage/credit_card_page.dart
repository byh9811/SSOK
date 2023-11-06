import 'package:flutter/material.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/screens/test.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  State<CreditCardPage> createState() => _IdPageState();
}

class _IdPageState extends State<CreditCardPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.1),
        introText(),
        SizedBox(height: screenHeight * 0.08),
        contentBox(
          context,
          Column(
            children: [
              Expanded(
                child: Text(
                  "등록된 카드가 없습니다",
                  style: TextStyle(color: Color(0xFF989898)),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.06,
                width: screenWidth * 0.7,
                child: registerButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ServiceAggreementPage(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/creditcard/create');
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          0.27,
        ),
      ],
    );
  }

  Widget introText() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.08),
          child: Row(
            children: [
              Text(
                "연동 카드",
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF00ADEF),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "로 결제하고",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.13),
          child: Row(
            children: [
              Text(
                "포켓머니",
                style: TextStyle(fontSize: 20, color: Color(0xFF00496F)),
              ),
              Text(
                "를 받을 수 있어요",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
