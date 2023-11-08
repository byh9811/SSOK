import 'package:flutter/material.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/http/http.dart';

class NotRegisteredPocket extends StatefulWidget {
  const NotRegisteredPocket({Key? key}) : super(key: key);

  @override
  State<NotRegisteredPocket> createState() => _NotRegisteredPocketState();
}

class _NotRegisteredPocketState extends State<NotRegisteredPocket> {
  ApiService apiService = ApiService();
  void makeAccount() async {
    final response = await apiService.postRequest('receipt-service/card',{}, TokenManager().accessToken);
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.of(context).pushReplacementNamed('/pocket/account/create');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.08),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                introText(),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: screenWidth * 0.13),
                  child: importantText(
                    text: "※ 잔금/환경 포인트를 적립할 수 있어요",
                    widthSize: 0.25,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5.0),
              child: Image.asset(
                'assets/pigcoin.png',
                height: 80,
                width: 80,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.06),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.1),
            child: importantText(
              text: "※ 포켓을 만들기 위해서 계좌연동이 필요해요",
              widthSize: 0.28,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.005),
        emptyAccount(),
      ],
    );
  }

  Widget introText() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.04),
          child: Row(
            children: [
              Text(
                "포켓머니",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF00ADEF),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "를 만들고",
                  style: TextStyle(
                    color: Color(0xFF00496F),
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.1),
          child: Row(
            children: [
              Text(
                "매달",
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF00ADEF),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "포인트를 받아요",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF00496F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget importantText({required String text, required double widthSize}) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * widthSize,
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: Color(0xFFBABABA)),
      ),
    );
  }

  Widget emptyAccount() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.only(left: screenWidth * 0.12, right: screenWidth * 0.12),
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.23,
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.16,
              alignment: Alignment.center,
              child: Text(
                "등록된 계좌가 없습니다",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 30,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceAggreementPage(
                      onTap: () {
                        makeAccount();
                      },
                    ),
                  ),
                );
              },
              child: const Text("+"),
            ),
          ],
        ),
      ),
    );
  }
}
