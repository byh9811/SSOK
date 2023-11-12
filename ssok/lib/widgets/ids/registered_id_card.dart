import 'package:flutter/material.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';

import '../../dto/registration_card.dart';

class RegisteredIdCard extends StatefulWidget {
  const RegisteredIdCard({
    Key? key,
    this.registrationCard,
  }) : super(key: key);
  final RegistrationCard? registrationCard;
  @override
  State<RegisteredIdCard> createState() => _RegisteredIdCardState();
}

class _RegisteredIdCardState extends State<RegisteredIdCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return contentBox(
      context,
      Column(
        children: [
          Expanded(
            child: Text(
              widget.registrationCard!.registrationCardName,
              style: TextStyle(color: Color(0xFF989898)),
            ),
          ),
          Text(
            widget.registrationCard!.registrationCardPersonalNumber,
            style: TextStyle(color: Color(0xFF989898)),
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
    );
  }
}
