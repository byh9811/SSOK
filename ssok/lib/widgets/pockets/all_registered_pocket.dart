import 'package:flutter/material.dart';
import 'package:ssok/widgets/pockets/childrens/my_account.dart';

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
        MyPocket(),
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

class MyPocket extends StatefulWidget {
  const MyPocket({super.key});

  @override
  State<MyPocket> createState() => _MyPocketState();
}

class _MyPocketState extends State<MyPocket> {
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
          color: Color(0xFF00496F),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.018, left: 13.0),
              child: Row(
                children: [
                  Icon(
                    Icons.paid,
                    color: Colors.white,
                    size: 23,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1.0, left: 3.0),
                    child: Text(
                      "포켓머니",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.07, right: 5.0),
              child: Row(
                children: [
                  Text(
                    "0원",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/pocket/transfer');
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          child: Text("이체"),
                        ),
                        Container(
                          height: screenHeight * 0.022,
                          width: 1,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          color: Colors.white,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/pocket/donation');
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          child: Text("기부"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
