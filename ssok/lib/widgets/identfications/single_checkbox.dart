import 'package:flutter/material.dart';

class SingleCheckbox extends StatelessWidget {
  const SingleCheckbox({
    Key? key,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.07),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: onTap,
                  icon: Icon(
                    Icons.done,
                    color: isActive ? activeColor : inactiveColor,
                    size: 25.0,
                  ),
                ),
                Expanded(child: Text(label)),
              ],
            ),
          )),
    );
  }
}
