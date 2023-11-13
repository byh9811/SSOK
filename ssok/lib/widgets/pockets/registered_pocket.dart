import 'package:flutter/material.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/pockets/childrens/my_account.dart';

class RegisteredPocket extends StatefulWidget {
  const RegisteredPocket({Key? key}) : super(key: key);

  @override
  State<RegisteredPocket> createState() => RegisteredPocketState();
}

class RegisteredPocketState extends State<RegisteredPocket> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        // SizedBox(height: screenHeight * 0.07),
        // introText(),
        SizedBox(height: screenHeight * 0.04),
        introText2(),
        SizedBox(height: screenHeight * 0.03),
        MyAccount(),
        SizedBox(height: screenHeight * 0.025),
        EmptyPocket(),
      ],
    );
  }

  Widget introText() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.1),
      child: Row(
        children: [
          Text(
            "마지막",
            style: TextStyle(
              fontSize: 27,
              color: Color(0xFF00ADEF),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              "이에요.",
              style: TextStyle(
                color: Color(0xFF00496F),
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget introText2() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "포켓머니",
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF00ADEF),
                ),
              ),
              Text(
                "를 생성해서",
                style: TextStyle(
                  color: Color(0xFF00496F),
                  fontSize: 25,
                ),
              ),
            ],
          ),
          Text(
            "적립금을 모아요.",
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFF00496F),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyPocket extends StatefulWidget {
  const EmptyPocket({super.key});

  @override
  State<EmptyPocket> createState() => _EmptyPocketState();
}

class _EmptyPocketState extends State<EmptyPocket> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.115,
        decoration: BoxDecoration(
          color: Color(0xFF00496F),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 13.0),
              child: Row(
                children: [
                  Icon(
                    Icons.paid,
                    color: Colors.white,
                    size: 23,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1.0, left: 3.0),
                    child: Text(
                      "포켓머니",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 35,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceAggreementPage(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/pocket/pocket/create');
                      },
                    ),
                  ),
                );
              },
              child: const Text("+"),
            ),
          ],
        ),
      ),
    );
  }
}
