import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  ApiService apiService = ApiService();
  String loginId = TokenManager().loginId ?? "";
  void introStateChange() async {
    if (loginId != "") {
      final response = await apiService.postRawRequest(
        'member-service/member/agreement',
        loginId,
        TokenManager().accessToken,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context).pushNamed('/main');
      } else {
        throw Exception('Failed to load');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w700),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            // 페이지1
            PageViewModel(
              title: "시작하기",
              bodyWidget: Column(
                children: [
                  Text(
                    "회원가입을 축하합니다.",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "SSOK에 오신 것을 환영해요.",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              image: Image.asset('assets/logo.png'),
              decoration: pageDecoration,
            ),

            // 페이지2
            PageViewModel(
              title: "지갑",
              bodyWidget: Text(
                "SSOK은 OCR 서비스을 이용한 신분증, 마이데이터을 활용한 카드 뿐만아니라 명함, 전자영수증까지 한번에 관리할 수있어요",
                style: TextStyle(fontSize: 18),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "위치기반 서비스",
              bodyWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "* SSOK은 명함 교환을 위한 받기 또는 주기를 클릭 시 위치 기반 서비스를 사용해요",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "* 명함 교환 시 블루투스 nearbyconnection기술을 사용하기 때문에 교환을 위해선 반드시 필요해요",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "* 또한 명함 교환 시 교환 장소도 저장할 수있어요",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              image: Image.asset('assets/intro3.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "위치기반 서비스",
              bodyWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "* 교환된 명함은 지도에서 확인할 수 있고, 이 때 내 현재 위치 버튼 클릭 시 내 주변 교환 장소도 알 수있어요",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "* 앱 항상 허용 시 앱이 닫혀 있거나 사용하지 않을 때도 기기의 위치 데이터를 사용해요",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "* 앱 종료 시 혹은 사용하고 싶지 않다면 설정에서 앱 사용중에만 허용 또는 허용안함으로 변경할 수 있어요.",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              image: Image.asset('assets/intro4.png', width: 270),
              decoration: pageDecoration,
            ),
          ],
          next: Text("다음", style: TextStyle(fontWeight: FontWeight.w600)),
          done: Text("SSOK 시작", style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () {
            introStateChange();
          },
        ),
      ),
    );
  }
}
