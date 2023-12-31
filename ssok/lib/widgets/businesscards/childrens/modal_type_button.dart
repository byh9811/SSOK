import 'package:flutter/material.dart';

class ModalTypeButton extends StatelessWidget {
  const ModalTypeButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.ontap,
    required this.color,
    required this.splashColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Function() ontap;
  final Color color;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
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
          color: color,
          child: InkWell(
            splashColor: splashColor,
            onTap: ontap,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Color(0xFF4C4C4C),
                  size: 40,
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  title,
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
