import 'package:flutter/material.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/ids/childrens/id_info_text.dart';
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
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/registration_card_color.png'),
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
                          "주민등록증",
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
                  idInfoText(context, "이름", widget.registrationCard!.registrationCardName),
                  SizedBox(height: screenHeight * 0.01),
                  idInfoText(context, "주민번호", widget.registrationCard!.registrationCardPersonalNumber),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/id/detail');
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

// class _RegisteredIdCardState extends State<RegisteredIdCard> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return contentBox(
//       context,
//       Column(
//         children: [
//           Expanded(
//             child: Text(
//               widget.registrationCard!.registrationCardName,
//               style: TextStyle(color: Color(0xFF989898)),
//             ),
//           ),
//           Text(
//             widget.registrationCard!.registrationCardPersonalNumber,
//             style: TextStyle(color: Color(0xFF989898)),
//           ),
//           SizedBox(
//             height: screenHeight * 0.06,
//             width: screenWidth * 0.7,
//             child: registerButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => ServiceAggreementPage(
//                       onTap: () {
//                         Navigator.of(context)
//                             .pushReplacementNamed('/id/create');
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//       0.23,
//     );
//   }
// }