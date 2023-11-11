import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:html';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:ssok/dto/business_card_data.dart';
import 'package:ssok/dto/business_card_data_map.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class BusinessCardMapPage extends StatefulWidget {
  const BusinessCardMapPage({super.key});

  @override
  State<BusinessCardMapPage> createState() => _BusinessCardMapPageState();
}

class _BusinessCardMapPageState extends State<BusinessCardMapPage> {
  late NaverMapController mapController;
  ApiService apiService = ApiService();
  NaverMapViewOptions options = const NaverMapViewOptions();
  NLatLng? currentLocation;
  Location location = Location();
  /* 명함 리스트 초기화 */
  late List<BusinessCardDataMap> businessCardDataMap = [];
  late HashMap<String, String> businessCardIdToAddr = HashMap();

  void bringBusinessCardListMap() async {
    final response = await apiService.getRequest(
        'namecard-service/map', TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['response'] is List<dynamic>) {
        final responseList = jsonData['response'] as List<dynamic>;
        setState(() {
          businessCardDataMap = responseList
              .map((data) => BusinessCardDataMap.fromJson(data))
              .toList();
          addMarkers();
        });
      } else {
        throw Exception('Invalid JSON format: "response" is not an array');
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    bringBusinessCardListMap();
  }

  void _checkLocationPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
    _getLocation();
  }

  void _getLocation() async {
    LocationData? locationData = await location.getLocation();
    setState(() {
      currentLocation =
          NLatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  String parseAddress(Map<String, dynamic> jsonData) {
    final area1 = jsonData['results'][0]['region']['area1']['name'];
    final area2 = jsonData['results'][0]['region']['area2']['name'];
    final area3 = jsonData['results'][0]['region']['area3']['name'];
    final area4 = jsonData['results'][0]['region']['area4']['name'];

    return '$area1 $area2 $area3 $area4';
  }
  Future<String> getAddressFromLatLng(double lat, double lon) async {
    final String clientId = '6sfqyu6her'; // 여기에 클라이언트 ID를 입력하세요
    final String clientSecret = 'cG12rGByf6VklpfZc0O7lW5KxUgqAh5GcGqAzW68'; // 여기에 클라이언트 Secret을 입력하세요

    final response = await http.get(
      Uri.parse('https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lon,$lat&sourcecrs=epsg:4326&orders=legalcode&output=json'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': clientId,
        'X-NCP-APIGW-API-KEY': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return parseAddress(jsonData); // 위에서 정의한 parseAddress 함수 사용
    } else {
      throw Exception('Failed to get address from Naver API');
    }
  }


  void addMarkers() async{
    if (mapController == null || businessCardDataMap.isEmpty) {
      return;
    }
    for (final data in businessCardDataMap) {
      /** 위도 경도를 주소로 반환해서 caption에 넣어야 함. */
      /**                */
      String address = await getAddressFromLatLng(data.lat, data.lon);
      businessCardIdToAddr[data.exchangeSeq.toString()] = address;
      // target: currentLocation ?? NLatLng(37.5666102, 126.9783881),
      final marker = NMarker(
        id: data.exchangeSeq.toString(),
        position: NLatLng(data.lat, data.lon),
        caption: NOverlayCaption(text: data.namecardName,color: Colors.black, textSize: 15),
        // icon: data.namecardImage
        // data.namecardImage != null ? NOverlayImage.fromWidget(widget: Image.network(data.namecardImage), size: size, context: context) : NOverlayImage.fromAssetImage("assets/logo.png")
        // icon: NOverlayImage.fromWidget(widget:Image.network(data.namecardImage, errorBuilder: Image.asset("assets/logo.png")))
        // icon: NOverlayImage.fromAssetImage("assets/logo.png")
        // icon: NOverlayImage..fromAssetImage(data.namecardImage)
        // icon: {
        //   url: 'data.namecardIMage'
        // }
      );

      mapController.addOverlay(marker);
      // 마커 클릭시 모달 보여주기.
      marker.setOnTapListener((NMarker marker) {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            final businessCard = businessCardDataMap
                .firstWhere((card) => card.exchangeSeq.toString() == marker.info.id);

            return Container(
              height: 300,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200, // 이미지의 너비
                    height: 100, // 이미지의 높이
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover, // 이미지를 컨테이너에 맞추도록 조정
                        image: NetworkImage(businessCard.namecardImage),
                      ),
                      borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 (선택 사항)
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    businessCard.namecardName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    businessCard.namecardCompany,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    businessCard.namecardJob,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${businessCardIdToAddr[marker.info.id]}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "지도로 보기",
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
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        // color: Colors.greenAccent,
        child: _naverMapSection(),
      ),
    );
  }

  Widget _naverMapSection() {
    // final mapPadding = EdgeInsets.only(bottom: drawerHeight - safeArea.bottom);

    return NaverMap(
      options: NaverMapViewOptions(
        indoorEnable: true,
        locationButtonEnable: true,
        consumeSymbolTapEvents: true,
        initialCameraPosition: NCameraPosition(
            target: currentLocation ?? NLatLng(37.5666102, 126.9783881),
            zoom: 15),
      ),
      onMapReady: onMapReady,
      // onMapTapped: onMapTapped,
      // onSymbolTapped: onSymbolTapped,
      // onCameraChange: onCameraChange,
      // onCameraIdle: onCameraIdle,
      // onSelectedIndoorChanged: onSelectedIndoorChanged,
    );
  }

  void onMapReady(NaverMapController controller) {
    mapController = controller;
    addMarkers();
  }
}