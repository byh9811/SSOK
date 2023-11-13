import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/modals/business_memo_modal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:math';

import 'package:http/http.dart' as http;

class BusinessCardDetailPage extends StatefulWidget {
  const BusinessCardDetailPage({super.key});

  @override
  State<BusinessCardDetailPage> createState() => _BusinessCardDetailPage();
}

class _BusinessCardDetailPage extends State<BusinessCardDetailPage> {
  @override
  Widget build(BuildContext context) {
    final exchangeSeq = ModalRoute.of(context)!.settings.arguments as int;

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
      body: BusinessCardDetail(exchangeSeq: exchangeSeq),
    );
  }
}

class BusinessCardDetail extends StatefulWidget {
  final int exchangeSeq;
  const BusinessCardDetail({super.key, required this.exchangeSeq});

  @override
  State<BusinessCardDetail> createState() => _BusinessCardDetail(exchangeSeq);
}

class NameCardHead {
  late String? nameCardImage;
  late String? nameCardName;
  late String? nameCardJob;
  late int? nameCardMemberSeq;
  late int? exchangeSeq;

  NameCardHead(this.nameCardImage, this.nameCardName, this.nameCardJob,
      this.nameCardMemberSeq, this.exchangeSeq);
}

class NameCardBody {
  late String? nameCardCompany;
  late String? nameCardWebsite;
  late String? nameCardAddress;
  late String? nameCardPhone;
  late String? nameCardTel;
  late String? nameCardFax;
  late String? nameCardEmail;
  NameCardBody(
      this.nameCardCompany,
      this.nameCardWebsite,
      this.nameCardAddress,
      this.nameCardPhone,
      this.nameCardTel,
      this.nameCardFax,
      this.nameCardEmail);
}

class NameCardPos {
  late double? lat;
  late double? lon;

  NameCardPos(this.lat, this.lon);
}

class _BusinessCardDetail extends State<BusinessCardDetail> {
  final int exchangeSeq;
  late NameCardHead nameCardHead;
  late NameCardBody nameCardBody;
  late NameCardPos nameCardPos;

  _BusinessCardDetail(this.exchangeSeq);
  ApiService apiService = ApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNameCardDetail();
  }

  void getNameCardDetail() async {
    final response = await apiService.getRequest(
        "namecard-service/$exchangeSeq", TokenManager().accessToken);
    final data = jsonDecode(utf8.decode(response.bodyBytes))["response"];
    print("getNameCardDetail");
    print(data);

    if (response.statusCode == 200) {
      setState(() {
        nameCardHead = NameCardHead(data["namecardImage"], data["namecardName"],
            data["namecardJob"], data["memberSeq"], data["exchangeSeq"]);
        nameCardBody = NameCardBody(
            data["namecardCompany"],
            data["namecardWebsite"],
            data["namecardAddress"],
            data["namecardPhone"],
            data["namecardTel"],
            data["namecardFax"],
            data["namecardEmail"]);
        nameCardPos = NameCardPos(data["lat"], data["lon"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
        child: Column(
          children: [
            BusinessCardDetailHeader(nameCardHead: nameCardHead),
            SizedBox(height: screenHeight * 0.03),
            BusinessCardDetailBody(nameCardBody: nameCardBody),
            SizedBox(height: screenHeight * 0.02),
            BusinessCardDetailMap(nameCardPos: nameCardPos),
          ],
        ),
      ),
    );
  }
}

class BusinessCardDetailHeader extends StatefulWidget {
  final NameCardHead nameCardHead;
  const BusinessCardDetailHeader({super.key, required this.nameCardHead});

  @override
  State<BusinessCardDetailHeader> createState() =>
      _BusinessCardDetailHeaderState(nameCardHead);
}

class _BusinessCardDetailHeaderState extends State<BusinessCardDetailHeader> {
  bool _isBack = true;
  double _angle = 0;
  final NameCardHead nameCardHead;
  _BusinessCardDetailHeaderState(this.nameCardHead);

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
                        child: _isBack
                            ? Image.network(
                                nameCardHead.nameCardImage.toString())
                            : null),
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
            padding: EdgeInsets.only(top: screenHeight * 0.006),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("/businesscard/history",
                    arguments: nameCardHead.exchangeSeq);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
        Row(
          children: [
            Text(
              nameCardHead.nameCardName.toString(),
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
                nameCardHead.nameCardJob.toString(),
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
  final NameCardBody nameCardBody;
  const BusinessCardDetailBody({super.key, required this.nameCardBody});

  @override
  State<BusinessCardDetailBody> createState() =>
      _BusinessCardDetailBodyState(nameCardBody);
}

class _BusinessCardDetailBodyState extends State<BusinessCardDetailBody> {
  final NameCardBody nameCardBody;
  _BusinessCardDetailBodyState(this.nameCardBody);

  Future<void> _launchInMap(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // _launchURL 함수는 주어진 URL을 엽니다.
  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
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
        Row(children: [
          Text(
            nameCardBody.nameCardCompany.toString(),
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
                Uri uri = Uri.parse(
                    "https://" + nameCardBody.nameCardWebsite.toString());
                _launchURL(uri);
              },
              icon: Icon(Icons.home_repair_service_rounded),
            ),
          )
        ]),
        SizedBox(height: screenHeight * 0.01),
        Row(
          children: [
            Text(
              nameCardBody.nameCardAddress.toString(),
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
                    toLaunch = Uri.parse(
                        'nmap://search?query=${nameCardBody.nameCardAddress}');
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
              "휴대폰 : " + nameCardBody.nameCardPhone.toString(),
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
                  _makePhoneCall(nameCardBody.nameCardPhone.toString());
                },
                icon: Icon(Icons.call),
              ),
            )
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        nameCardBody.nameCardTel != null
            ? Text(
                "회사 : " + nameCardBody.nameCardTel.toString(),
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            : SizedBox(height: 0),
        SizedBox(height: screenHeight * 0.01),
        Text(
          "FAX : " + nameCardBody.nameCardFax.toString(),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          "Email : " + nameCardBody.nameCardEmail.toString(),
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

String parseAddress(Map<String, dynamic> jsonData) {
  final area1 = jsonData['results'][0]['region']['area1']['name'];
  final area2 = jsonData['results'][0]['region']['area2']['name'];
  final area3 = jsonData['results'][0]['region']['area3']['name'];
  final area4 = jsonData['results'][0]['region']['area4']['name'];

  return '$area1 $area2 $area3 $area4';
}

Future<String> getAddressFromLatLng(double lat, double lon) async {
  const String clientId = '6sfqyu6her'; // 여기에 클라이언트 ID를 입력하세요
  const String clientSecret =
      'cG12rGByf6VklpfZc0O7lW5KxUgqAh5GcGqAzW68'; // 여기에 클라이언트 Secret을 입력하세요

  final response = await http.get(
    Uri.parse(
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lon,$lat&sourcecrs=epsg:4326&orders=legalcode&output=json'),
    headers: {
      'X-NCP-APIGW-API-KEY-ID': clientId,
      'X-NCP-APIGW-API-KEY': clientSecret,
    },
  );
  print("getAddressFromLatLng");
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData["status"]["code"] == 0){
      return parseAddress(jsonData); // 위에서 정의한 parseAddress 함수 사용
    }
      return "위치 정보를 파악할 수 없습니다.";
  } else {
    throw Exception('Failed to get address from Naver API');
  }
}

class BusinessCardDetailMap extends StatefulWidget {
  final NameCardPos nameCardPos;
  const BusinessCardDetailMap({super.key, required this.nameCardPos});

  @override
  State<BusinessCardDetailMap> createState() =>
      _BusinessCardDetailMapState(nameCardPos);
}

class _BusinessCardDetailMapState extends State<BusinessCardDetailMap> {
  late NaverMapController mapController;
  NaverMapViewOptions options = const NaverMapViewOptions();
  late NameCardPos nameCardPos;
  late String positionName = "zz";

  _BusinessCardDetailMapState(this.nameCardPos);

  Future<void> _launchInMap(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAdd(nameCardPos.lat ?? 0, nameCardPos.lon ?? 0);
  }

  void getAdd(double lat, double lon) async {
    String addressName = await getAddressFromLatLng(lat, lon);
    setState(() {
      positionName = addressName;
    });
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
              child: _naverMapSection(
                  nameCardPos.lat ?? 35.203845, nameCardPos.lon ?? 126.8104095),
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
              positionName.toString(),
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

  Widget _naverMapSection(double lat, double lon) {
    return NaverMap(
      options: NaverMapViewOptions(
        indoorEnable: true,
        consumeSymbolTapEvents: true,
        initialCameraPosition:
            NCameraPosition(target: NLatLng(lat, lon), zoom: 10),
      ),
      onMapReady: onMapReady,
    );
  }

  void onMapReady(NaverMapController controller) {
    mapController = controller;
    print(nameCardPos.lat.toString() + " " + nameCardPos.lat.toString());
    final marker = NMarker(
        id: '1',
        position: NLatLng(
            nameCardPos.lat ?? 35.203845, nameCardPos.lon ?? 126.8104095));
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
