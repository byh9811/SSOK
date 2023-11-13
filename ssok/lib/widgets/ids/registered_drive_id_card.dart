import 'package:flutter/material.dart';
import 'package:ssok/dto/license.dart';
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

    return contentBox(
      context,
      Column(
        children: [
          Expanded(
            child: Transform(
              transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // 3D 효과를 위한 원근감 설정
              ..rotateX(3.14159 / 1 * (_animation.value / 3.14159)),
                // ..rotateY(_animation.value), // Y축을 중심으로 회전
                // ..rotateZ(3.14159 / 2 * (_animation.value / 3.14159)), // 90도 회전
              alignment: FractionalOffset.center,
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
                  idInfoText(context, "이름", widget.license!.licenseName),
                  idInfoText(context, "주민번호", widget.license!.licensePersonalNumber),
                  SizedBox(height: screenHeight * 0.01),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: _toggleAnimation,
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
