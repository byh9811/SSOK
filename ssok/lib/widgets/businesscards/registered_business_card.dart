import 'package:flutter/material.dart';

class RegisteredBusinessCard extends StatefulWidget {
  const RegisteredBusinessCard({super.key});

  @override
  State<RegisteredBusinessCard> createState() => _RegisteredBusinessCardState();
}

class _RegisteredBusinessCardState extends State<RegisteredBusinessCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyBusinessCard(),
        Container(
          alignment: Alignment.center,
          width: 300,
          height: 400,
          child: Text("목록"),
        )
      ],
    );
  }
}

class MyBusinessCard extends StatelessWidget {
  const MyBusinessCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "내 명함",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.06, screenHeight * 0.03),
                    backgroundColor: Color(0xFF3B8CED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "명함 교환",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              )
            ],
          ),
          AspectRatio(
            aspectRatio: 9 / 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.amber,
              ),
            ),
          )
        ],
      ),
    );
  }
}
