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
      // 여기에 면허정보가 들어가야함. 클릭하면 상세정보 이동.
      Column(
        children: [
          Expanded(
            child: Text(
              "등록된 운전면허증이 있습니다",
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
    );
  }
}
