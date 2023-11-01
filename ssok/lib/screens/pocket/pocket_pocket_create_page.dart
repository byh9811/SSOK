import 'package:flutter/material.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class PocketPocketCreatePage extends StatefulWidget {
  const PocketPocketCreatePage({super.key});

  @override
  State<PocketPocketCreatePage> createState() => _PocketPocketCreatePageState();
}

class _PocketPocketCreatePageState extends State<PocketPocketCreatePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.18),
            introText(),
            SizedBox(height: screenHeight * 0.05),
            MySamplePocket(),
            SizedBox(height: screenHeight * 0.15),
            MainButton(
              title: "메인으로",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget introText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "포켓머니",
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFF00ADEF),
          ),
        ),
        Text(
          "가",
          style: TextStyle(
            color: Color(0xFF00496F),
            fontSize: 25,
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          "생성",
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFF00ADEF),
          ),
        ),
        Text(
          "되었습니다.",
          style: TextStyle(
            color: Color(0xFF00496F),
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}

class MySamplePocket extends StatefulWidget {
  const MySamplePocket({super.key});

  @override
  State<MySamplePocket> createState() => _MySamplePocketState();
}

class _MySamplePocketState extends State<MySamplePocket> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.018, left: 13.0),
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
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.012, left: screenWidth * 0.08),
              child: Text(
                "0원",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
