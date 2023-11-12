import 'package:flutter/material.dart';
import 'package:ssok/dto/license.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';

class RegisteredDriveIdCard extends StatefulWidget {
  const RegisteredDriveIdCard({
    Key? key,
    this.license,
  }) : super(key: key);
  final License? license;
  @override
  State<RegisteredDriveIdCard> createState() => _RegisteredDriveIdCardState();
}

class _RegisteredDriveIdCardState extends State<RegisteredDriveIdCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return contentBox(
      context,
      Column(
        children: [
          Expanded(
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/license_card_color.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 45,
                      color: Colors.white54,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "운전면허증",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.19,
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03, top: screenHeight * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("이름"),
                  Padding(
                    padding:
                        EdgeInsets.only(left: screenWidth * 0.01, top: 3.0),
                    child: Text(
                      "나종현",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text("주민번호"),
                  Padding(
                    padding:
                        EdgeInsets.only(left: screenWidth * 0.01, top: 3.0),
                    child: Text(
                      "980113-1******",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/drive/id/detail');
                        },
                        child: Text(
                          "자세히",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      0.5,
    );
  }
}
