import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';

class IDPage extends StatefulWidget {
  const IDPage({Key? key}) : super(key: key);

  @override
  State<IDPage> createState() => _IdPageState();
}

class _IdPageState extends State<IDPage> {
  final String assetName = '';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.04),
        Row(
          children: [
            introText(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 15.0),
              child: SvgPicture.asset(
                "assets/id.svg",
                height: 45,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.03),
        titleText(text: "주민등록증"),
        contentBox(
          context,
          Column(
            children: [
              Expanded(
                child: Text(
                  "등록된 주민등록증이 없습니다",
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
                                .pushReplacementNamed('/id/create');
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          0.23,
        ),
        SizedBox(height: screenHeight * 0.03),
        titleText(text: "운전면허증"),
        contentBox(
          context,
          Column(
            children: [
              Expanded(
                child: Text(
                  "등록된 운전면허증이 없습니다",
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
                                .pushReplacementNamed('/drive/id/create');
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          0.23,
        )
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
                "디지털 신분증",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF00496F),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Text(
                  "으로",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "사용할 수 있어요",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget titleText({required String text}) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0, left: screenWidth * 0.1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 21,
          ),
        ),
      ),
    );
  }
}
