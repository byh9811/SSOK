import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/ids/childrens/id_info_text.dart';

import '../../http/http.dart';
import '../../http/token_manager.dart';

class DriveIdDetailPage extends StatefulWidget {
  const DriveIdDetailPage({super.key});

  @override
  State<DriveIdDetailPage> createState() => _DriveIdDetailPageState();
}

class _DriveIdDetailPageState extends State<DriveIdDetailPage> {

  ApiService apiService = ApiService();
  late String licenseName = "";
  late String licensePersonalNumber = "";
  late String licenseType = "";
  late String licenseAddress = "";
  late String licenseNumber = "";
  late String licenseRenewStartDate = "";
  late String licenseRenewEndDate = "";
  late String licenseCondition = "";
  late String licenseCode = "";
  late String licenseIssueDate = "";
  late String licenseAuthority = "";

  @override
  void initState() {
    super.initState();
    getDriveId();
  }
  void getDriveId() async {
    final response = await apiService.getRequest(
        "idcard-service/license", TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final tempRes = jsonData['response'];

      setState(() {
        licenseName = tempRes['licenseName'];
        licensePersonalNumber = tempRes['licensePersonalNumber'];
        licenseType = tempRes['licenseType'];
        licenseAddress = tempRes['licenseAddress'];
        licenseNumber = tempRes['licenseNumber'];
        licenseRenewStartDate = tempRes['licenseRenewStartDate'];
        licenseRenewEndDate = tempRes['licenseRenewEndDate'];
        licenseCondition = tempRes['licenseCondition'];
        licenseCode = tempRes['licenseCode'];
        licenseIssueDate = tempRes['licenseIssueDate'];
        licenseAuthority = tempRes['licenseAuthority'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "운전면허증",
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // 원하는 색상으로 변경
        ),
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenHeight * 0.21,
              width: screenWidth * 0.7,
              color: Colors.blue,
            ),
            SizedBox(height: screenHeight * 0.05),
            contentBox(
              context,
              Column(
                children: [
                  Container(
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
                            height: 40,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.03, top: screenHeight * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            idInfoText(context, "이름", licenseName),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "주민번호", licensePersonalNumber),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "종류", licenseType),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "주소", licenseAddress),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "면허번호", licenseNumber),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "갱신시작일자", licenseRenewStartDate),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "갱신최종일자", licenseRenewEndDate),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "조건", licenseCondition),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "코드", licenseCode),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "발급일자", licenseIssueDate),
                            SizedBox(height: screenHeight * 0.01),
                            idInfoText(context, "인증기관", licenseAuthority),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              0.5,
            ),
          ],
      ),
    );
  }
}


//=========================================================
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:ssok/widgets/content_box.dart';
// import 'package:ssok/widgets/ids/childrens/id_info_text.dart';
//
// import '../../http/http.dart';
// import '../../http/token_manager.dart';
// class LicenseDetailWidget extends StatelessWidget {
//   final double screenHeight;
//   final double screenWidth;
//   final String license; // License 타입의 객체를 가정합니다.
//
//   LicenseDetailWidget({required this.screenHeight, required this.screenWidth, required this.license});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Container(
//             width: screenWidth,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/license_card_color.png'),
//                 fit: BoxFit.cover,
//               ),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10.0),
//                 topRight: Radius.circular(10.0),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Image.asset(
//                     'assets/logo.png',
//                     height: 45,
//                     color: Colors.white54,
//                   ),
//                 ),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Text(
//                         "운전면허증",
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           width: screenWidth,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(10.0),
//                 bottomRight: Radius.circular(10.0)),
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(
//                 left: screenWidth * 0.03, top: screenHeight * 0.01),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 idInfoText(context, "이름", "license.licenseName"),
//                 idInfoText(context, "주민번호", "license.licensePersonalNumber"),
//                 // ... 나머지 정보 표시
//                 SizedBox(height: screenHeight * 0.01),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pushNamed('/drive/id/detail');
//                     },
//                     child: Text(
//                       "자세히",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
