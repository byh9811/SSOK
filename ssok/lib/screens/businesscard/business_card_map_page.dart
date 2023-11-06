import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class BusinessCardMapPage extends StatefulWidget {
  const BusinessCardMapPage({super.key});

  @override
  State<BusinessCardMapPage> createState() => _BusinessCardMapPageState();
}

class _BusinessCardMapPageState extends State<BusinessCardMapPage> {
  late NaverMapController mapController;
  NaverMapViewOptions options = const NaverMapViewOptions();
  NLatLng? currentLocation;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
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

  // Widget _naverMapSection() => NaverMap(
  //       options: const NaverMapViewOptions(
  //         indoorEnable: true,
  //         locationButtonEnable: false,
  //         consumeSymbolTapEvents: false,
  //       ),
  //       onMapReady: (controller) async {
  //         _mapController = controller;
  //         mapControllerCompleter.complete(controller);
  //       },
  //     );

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
    final marker1 =
        NMarker(id: '1', position: NLatLng(37.5666102, 126.9783881));
    mapController = controller;
    mapController.addOverlayAll({marker1});
    marker1.setOnTapListener((NMarker marker) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          return Container(
            height: screenHeight * 0.5,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('마커 정보'),
                Text(
                    '마커 위치: ${marker.position.latitude}, ${marker.position.longitude}'),
                // 여기에 다른 마커 정보를 표시하거나 사용자 정의 위젯을 추가할 수 있습니다.
              ],
            ),
          );
        },
      );
    });
  }
}
