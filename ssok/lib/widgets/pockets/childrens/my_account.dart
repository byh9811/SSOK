import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.115,
        decoration: BoxDecoration(
          color: Color(0xFF8B8B8B),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/pigcoin.png",
                    height: 35,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.09,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "홍길동의 통장",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "25,000원",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    height: screenHeight * 0.09,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0, right: 14.0),
                      child: IconButton(
                        icon: Icon(Icons.more_horiz),
                        color: Colors.white,
                        splashColor: Colors.white,
                        onPressed: () {},
                        iconSize: 28.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
