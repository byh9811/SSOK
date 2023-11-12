import 'package:flutter/material.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/ids/childrens/id_info_text.dart';

class IdDetailPage extends StatefulWidget {
  const IdDetailPage({super.key});

  @override
  State<IdDetailPage> createState() => _IdDetailPageState();
}

class _IdDetailPageState extends State<IdDetailPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "주민등록증",
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // 원하는 색상으로 변경
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenHeight * 0.21,
            width: screenWidth * 0.7,
            color: Colors.blue,
          ),
          SizedBox(height: screenHeight * 0.05),
          contentBox(
            context,
            Column(
              children: [
                Container(
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
                          height: 40,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight * 0.4,
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
                          idInfoText(context, "이름", "나종현"),
                          SizedBox(height: screenHeight * 0.01),
                          idInfoText(context, "주민번호", "980113-1******"),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            0.5,
          ),
        ],
      ),
    );
  }
}
