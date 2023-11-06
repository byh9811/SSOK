import 'package:flutter/material.dart';
import 'package:ssok/widgets/modals/business_memo_modal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:math';

class BusinessCardDetailPage extends StatelessWidget {
  const BusinessCardDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> businessCardInfo = {
      'namecardName': '홍길동',
      'namecardJob': 'Android Developer',
      'namecardCompany': 'Dev Team',
      'namecardAddress': '경기도 성남시 분당구 ...',
      'namecardPhone': '010-1111-2222',
      'namecardTel': '010-1111-2222',
      'namecardFax': '050-000-2222',
      'namecardEmail': 'i0364842@naver.com',
      'namecardWebsite': 'samsung.com',
    };
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "명함 상세",
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
      body: BusinessCardDetail(),
    );
  }
}

class BusinessCardDetail extends StatelessWidget {
  const BusinessCardDetail({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
        child: Column(
          children: [
            BusinessCardDetailHeader(),
            SizedBox(height: screenHeight * 0.03),
            BusinessCardDetailBody(),
            SizedBox(height: screenHeight * 0.02),
            BusinessCardDetailMap(),
          ],
        ),
      ),
    );
  }
}

class BusinessCardDetailHeader extends StatefulWidget {
  const BusinessCardDetailHeader({super.key});

  @override
  State<BusinessCardDetailHeader> createState() =>
      _BusinessCardDetailHeaderState();
}

class _BusinessCardDetailHeaderState extends State<BusinessCardDetailHeader> {
  bool _isBack = true;
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          child: GestureDetector(
            onTap: () => setState(() {
              _angle = (_angle + pi) % (2 * pi);
            }),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _angle),
              duration: Duration(milliseconds: 1000),
              builder: (BuildContext con, double val, _) {
                _isBack = (val >= (pi / 2)) ? false : true;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(val)
                    ..rotateZ(_isBack ? 0 : pi / 2), // 90도 회전
                  child: AspectRatio(
                    aspectRatio: 9 / 5,
                    child: Container(
                        decoration: BoxDecoration(
                          color: _isBack ? Colors.amber : Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        child: _isBack ? Text("뭐") : null),
                  ),
                );
              },
              onEnd: () {
                if (_angle == pi) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: screenWidth,
                              height: screenHeight,
                              color: Colors.transparent,
                            ),
                            Dialog(
                              child: WillPopScope(
                                onWillPop: () async {
                                  setState(() {
                                    _angle = 0;
                                  });
                                  return true; // true를 반환하면 뒤로가기 작업을 계속 수행, false를 반환하면 뒤로가기 작업을 무시
                                },
                                child: BusinessMemoModal(
                                  closeOnPress: () {
                                    Navigator.of(context).pop();
                                    setState(
                                      () {
                                        _angle = 0;
                                      },
                                    );
                                  },
                                  content: "안녕하십니까",
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(
                right: screenWidth * 0.008, top: screenHeight * 0.006),
            child: InkWell(
              onTap: () {},
              child: SizedBox(
                width: screenWidth * 0.2,
                child: Row(
                  children: [
                    Icon(Icons.timeline),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        "타임라인",
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "홍길동",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 2.0),
                    blurRadius: 3.0,
                    color: Colors.black12,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03, top: screenHeight * 0.01),
              child: Text(
                "전임 연구원",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class BusinessCardDetailBody extends StatefulWidget {
  const BusinessCardDetailBody({super.key});

  @override
  State<BusinessCardDetailBody> createState() => _BusinessCardDetailBodyState();
}

class _BusinessCardDetailBodyState extends State<BusinessCardDetailBody> {
  Future<void> _launchInMap(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    late Uri toLaunch;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header("부서위치"),
        Text(
          "삼성전자 주식회사",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          children: [
            Text(
              "서울특별시 종로구 인의동 123-4",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 1.0),
              child: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                iconSize: 22,
                onPressed: () {
                  setState(() {
                    toLaunch =
                        Uri.parse('nmap://search?query=서울특별시 종로구 인의동 123-4');
                    _launchInMap(toLaunch);
                  });
                },
                icon: Icon(Icons.pin_drop),
              ),
            )
          ],
        ),
        SizedBox(height: screenHeight * 0.035),
        header("연락처"),
        Row(
          children: [
            Text(
              "휴대폰 : 010-1111-2222",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 1.0),
              child: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                iconSize: 22,
                onPressed: () {
                  _makePhoneCall("010 - 1111 - 2222");
                },
                icon: Icon(Icons.call),
              ),
            )
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          "회사 : 012-345-6789",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          "FAX : 012-345-6789",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          "Email : i0364842@naver.com",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget header(String text) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Color(0xFFB2B2B2),
          ),
        ),
        Divider(
          height: screenHeight * 0.02,
          color: Color(0xFFB2B2B2),
        ),
      ],
    );
  }
}

class BusinessCardDetailMap extends StatefulWidget {
  const BusinessCardDetailMap({super.key});

  @override
  State<BusinessCardDetailMap> createState() => _BusinessCardDetailMapState();
}

class _BusinessCardDetailMapState extends State<BusinessCardDetailMap> {
  late NaverMapController mapController;
  NaverMapViewOptions options = const NaverMapViewOptions();
  Future<void> _launchInMap(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    late Uri toLaunch;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        header("명함 교환장소"),
        Stack(
          children: [
            SizedBox(
              width: screenWidth,
              height: screenHeight * 0.18,
              child: _naverMapSection(),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  toLaunch = Uri.parse(
                      'nmap://search?query=광주 광산구 임방울대로 332번길 29 1층 102호');
                  _launchInMap(toLaunch);
                });
              },
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.18,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Color(0xFF787676),
            ),
            Text(
              "광주 광산구 임방울대로 332번길 29 1층 102호",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _naverMapSection() {
    return NaverMap(
      options: NaverMapViewOptions(
        indoorEnable: true,
        consumeSymbolTapEvents: true,
        initialCameraPosition:
            NCameraPosition(target: NLatLng(37.5666102, 126.9783881), zoom: 16),
      ),
      onMapReady: onMapReady,
    );
  }

  void onMapReady(NaverMapController controller) {
    mapController = controller;
    final marker = NMarker(id: '1', position: NLatLng(37.5666102, 126.9783881));
    mapController = controller;
    mapController.addOverlay(marker);
  }

  Widget header(String text) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Color(0xFFB2B2B2),
          ),
        ),
        Divider(
          height: screenHeight * 0.02,
          color: Color(0xFFB2B2B2),
        ),
      ],
    );
  }
}
