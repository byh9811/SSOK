import 'package:flutter/material.dart';
import 'package:ssok/widgets/pockets/childrens/my_account.dart';
import 'package:ssok/widgets/pockets/childrens/my_pocket.dart';

class AllRegisteredPocket extends StatefulWidget {
  const AllRegisteredPocket({super.key});

  @override
  State<AllRegisteredPocket> createState() => _AllRegisteredPocketState();
}

class _AllRegisteredPocketState extends State<AllRegisteredPocket> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        MyAccount(),
        SizedBox(height: screenHeight * 0.02),
        MyPocket(
          onTap: () {
            Navigator.of(context).pushNamed('/pocket/history/list');
          },
        ),
        SizedBox(height: screenHeight * 0.03),
        Divider(
          height: 1,
          indent: screenWidth * 0.1,
          endIndent: screenWidth * 0.1,
          color: Color(0xFFB2B2B2),
        ),
        Image.asset(
          "assets/level.png",
          height: 40,
        )
      ],
    );
  }
}
