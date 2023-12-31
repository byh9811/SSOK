import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/frequents/confirm.dart';
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

class _RegisteredIdCardState extends State<RegisteredIdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  ApiService apiService = ApiService();
  late String registrationCardName = "";
  late String registrationCardPersonalNumber = "";
  late String registrationCardAddress = "";
  late String registrationCardIssueDate = "";
  late String registrationCardAuthority = "";
  late String registrationCardImage = "";

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
    getRegCard();
  }

  void getRegCard() async {
    final response = await apiService.getRequest(
        "idcard-service/registration", TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final tempRes = jsonData['response'];

      setState(() {
        registrationCardName = tempRes['registrationCardName'];
        registrationCardPersonalNumber =
            tempRes['registrationCardPersonalNumber'];
        registrationCardAddress = tempRes['registrationCardAddress'];
        registrationCardIssueDate = tempRes['registrationCardIssueDate'];
        registrationCardAuthority = tempRes['registrationCardAuthority'];
        registrationCardImage = tempRes['registrationCardImage'];
      });
    }
  }

  void removeIdCard() async {
    print("신분증을 삭제합니다.");
    final response = await apiService.postRequest(
        "idcard-service/registration/remove", null, TokenManager().accessToken);
    if (response.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 0);
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
    return GestureDetector(
      onTap: () {
        _toggleAnimation();
      },
      child: Padding(
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
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              height: 45,
                              color: Colors.white54,
                            ),
                            IconButton(onPressed: () {
                              confirmDialog(context, "주민등록증 삭제", "주민등록증을 삭제하시겠습니까?",(){removeIdCard();});
                              // updateStatus
                            }, icon: Icon(Icons.remove_circle), color: Colors.pink,),
                          ],
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
                      idInfoText(context, "이름",
                          widget.registrationCard!.registrationCardName),
                      SizedBox(height: screenHeight * 0.01),
                      idInfoText(
                          context,
                          "주민번호",
                          widget
                              .registrationCard!.registrationCardPersonalNumber),
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
            children: [
              _buildRotatedText(registrationCardAuthority, 20),
            ],
          ),
          Column(
            children: [
              _buildRotatedText('발급 일자: $registrationCardIssueDate', 18),
            ],
          ),
          Column(
            children: [
              _buildRotatedTextWithWrap(registrationCardAddress, 14),
            ],
          ),
          Column(
            children: [
              _buildRotatedText(registrationCardPersonalNumber, 18),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRotatedText(registrationCardName, 25),
              // Padding(
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRotatedText(String text, double fontSize) {
    return RotatedBox(
      quarterTurns: 1, // 90도 회전 (세로 텍스트로 만들기)
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }

  Widget _buildRotatedTextWithWrap(String text, double fontSize) {
    List<String> lines = _splitTextIntoLines(text, 35).reversed.toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return _buildRotatedText(line, fontSize);
      }).toList(),
    );
  }

  List<String> _splitTextIntoLines(String text, int chunkSize) {
    List<String> lines = [];
    for (var i = 0; i < text.length; i += chunkSize) {
      int end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      lines.add(text.substring(i, end));
    }
    return lines;
  }
}


