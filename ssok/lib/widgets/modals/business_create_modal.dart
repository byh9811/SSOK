import 'package:flutter/material.dart';

class BusinessCreateModal extends StatelessWidget {
  const BusinessCreateModal({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth * 0.75,
      height: screenHeight * 0.3,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Color(0xFF676767),
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            "내 명함 등록",
            style: TextStyle(
              color: Color(0xFF656363),
              fontSize: 24,
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              typeButton(context, () {
                Navigator.of(context).pushReplacementNamed('/test');
              }),
              typeButton(context, () {}),
              typeButton(context, () {
                Navigator.of(context).pushReplacementNamed('/createCardSelf');
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget typeButton(BuildContext context, Function() ontap) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.017,
        right: screenWidth * 0.017,
      ),
      child: SizedBox(
        width: screenWidth * 0.2,
        height: screenHeight * 0.11,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFFBEC4C6),
          child: InkWell(
            splashColor: Color(0xFFA8AEB1),
            onTap: ontap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera,
                  color: Color(0xFF4C4C4C),
                  size: 40,
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  "촬영",
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4C4C4C),
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
