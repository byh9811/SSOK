import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:ssok/dto/business_card_data.dart';
import 'package:ssok/dto/business_card_data_map.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

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

  void bringBusinessCardListMap() async {
    final response = await apiService.getRequest(
        'namecard-service/map', TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['response'] is List<dynamic>) {
        final responseList = jsonData['response'] as List<dynamic>;
        businessCardDataMap = responseList
            .map((data) => BusinessCardDataMap.fromJson(data))
            .toList();
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

    // businessCardDataMap에 있는 데이터를 사용하여 마커 추가
    for (final data in businessCardDataMap) {
      final marker = NMarker(
        id: data.exchangeSeq.toString(),
        position: NLatLng(data.lat, data.lon),
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(businessCard.namecardImage),
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
                    '위도 경도로 장소 찾아서 적기', // TODO: 장소 정보 표시
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '마커 위치: ${marker.position.latitude}, ${marker.position.longitude}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
    }
  }
}