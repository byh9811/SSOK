import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ssok/dto/license.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';
import 'childrens/id_info_text.dart';

class RegisteredDriveIdCard extends StatefulWidget {
  const RegisteredDriveIdCard({
    Key? key,
    this.license,
  }) : super(key: key);
  final License? license;

  @override
  State<RegisteredDriveIdCard> createState() => _RegisteredDriveIdCardState();
}

class _RegisteredDriveIdCardState extends State<RegisteredDriveIdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 3.14159) // 180도 회전
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isFrontVisible = _animation.value < 3.14 / 2;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // 3D 효과를 위한 원근감 설정
        ..rotateY(_animation.value), // Y축을 중심으로 회전
      alignment: FractionalOffset.center,
      child: isFrontVisible
          ? _buildFrontContent(context)
          : Transform(
              transform: Matrix4.identity()..rotateY(3.14159), // 180도 추가 회전
              alignment: FractionalOffset.center,
              child: _buildBackContent(context)),
    );
  }

  Widget _buildFrontContent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: contentBox(
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
            )),
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
                    idInfoText(context, "이름", widget.license!.licenseName),
                    SizedBox(height: screenHeight * 0.01),
                    idInfoText(
                        context, "주민번호", widget.license!.licensePersonalNumber),
                    SizedBox(height: screenHeight * 0.01),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: _toggleAnimation,
                          child: Text(
                            "자세히",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
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
      ),
    );
  }

  Widget _buildBackContent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.01),
        child: contentBox(
          context,
          Column(
            // Column 위젯을 이용하여 Expanded를 직접적인 자식으로 사용
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
                      Expanded(child: _driveIdContent(context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          0.5,
        ),
      ),
    );
  }

  Widget _driveIdContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 간격을 균등하게 조절
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRotatedText('발급일: $licenseIssueDate', 18),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _buildRotatedText('$licenseAuthority', 18),
              ),
            ],
          ),
          Column(
            children: [
              _buildRotatedText('코드: $licenseCode', 18),
            ],
          ),
          Column(
            children: [
              _buildRotatedText('조건: $licenseCondition', 18),
            ],
          ),
          Column(
            children: [
              _buildRotatedText('$licenseNumber', 25),
            ],
          ),
          Column(
            children: [
              _buildRotatedText('$licensePersonalNumber', 20),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRotatedText('$licenseName', 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _buildRotatedText('$licenseType', 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRotatedText(String text, double fontSize) {
    return RotatedBox(
      quarterTurns: 1,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: Colors.black),
      ),
    );
  }
}
