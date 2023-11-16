import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:ssok/dto/business_card_data.dart';

import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/loading/transfer_loading_page.dart';
import 'package:ssok/widgets/frequents/confirm.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';

class Endpoint {
  final String id;
  final String name;
  final String serviceId;

  Endpoint({required this.id, required this.name, required this.serviceId});
}

class BusinessCardReceiveBluetoothPage extends StatefulWidget {
  const BusinessCardReceiveBluetoothPage({super.key});

  @override
  State<BusinessCardReceiveBluetoothPage> createState() =>
      _BusinessCardReceiveBluetoothPageState();
}

class _BusinessCardReceiveBluetoothPageState
    extends State<BusinessCardReceiveBluetoothPage>
    with SingleTickerProviderStateMixin {
  ApiService apiService = ApiService();
  // final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};
  String? tempFileUri;
  Map<int, String> map = {};
  bool advertising = false;
  bool scanning = false;
  late MyNameCard myNamecardItem;
  List<Endpoint> discoveredEndpoints = [];
  Location location = Location();

  // void showDiscoveredEndpoints(BuildContext context) {
  //   double screenHeight = MediaQuery.of(context).size.height;

  //   showModalBottomSheet(
  //     context: context,
  //     barrierColor: Colors.transparent,
  //     builder: (builder) {
  //       return Container(
  //         height: screenHeight * 0.3,
  //         child: Column(
  //           children: discoveredEndpoints.map((endpoint) {
  //             return ListTile(
  //               title: Text("${endpoint.name} 님 발견!",
  //                   style: TextStyle(fontSize: 20)),
  //               subtitle: Text("ID: ${endpoint.id}"),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 // 선택한 디바이스에 대한 추가 동작 수행
  //                 Nearby().requestConnection(
  //                   userName,
  //                   endpoint.id,
  //                   onConnectionInitiated: (id, info) {
  //                     onConnectionInit(id, info);
  //                   },
  //                   onConnectionResult: (id, status) {
  //                     showSnackbar(status);
  //                   },
  //                   onDisconnected: (id) {
  //                     setState(() {
  //                       endpointMap.remove(id);
  //                     });
  //                     showSnackbar(
  //                         "Disconnected from: ${endpoint.name}, id $id");
  //                   },
  //                 );
  //               },
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

  void scanningStart() async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    try {
      bool a = await Nearby().startDiscovery(
        myNamecardItem.namecardName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          // show sheet automatically to request connection
          // Create an Endpoint object
          bool alreadyDiscovered =
              discoveredEndpoints.any((endpoint) => endpoint.id == id);

          if (!alreadyDiscovered) {
            Endpoint endpoint =
                Endpoint(id: id, name: name, serviceId: serviceId);

            // Add the endpoint to the list
            setState(() {
              discoveredEndpoints.add(endpoint);
            });
          }
        },
        onEndpointLost: (id) {
          // showSnackbar(
          //     "Lost discovered Endpoint: ${endpointMap[id]?.endpointName}, id $id");
        },
      );
      showSnackbar("스캔을 시작합니다.");
      setState(() {
        scanning = true;
      });
    } catch (e) {
      showSnackbar(e);
    }
    Future.delayed(const Duration(milliseconds: 10000), () async {
      await Nearby().stopDiscovery();
      // pointClear();
      stop();
      setState(() {
        scanning = false;
      });
      discoveredEndpoints.clear();
    });
  }

  void pointClear() async {
    await Nearby().stopAllEndpoints();
    setState(() {
      endpointMap.clear();
    });
  }

  void transfer(int namecardASeq, int namecardBSeq) async {
    LocationData locationData = await location.getLocation();
    final response = await apiService.postRequest(
        'namecard-service/exchange/single',
        {
          "namecardASeq": "$namecardASeq",
          "namecardBSeq": "$namecardBSeq",
          "lat": "${locationData.latitude}",
          "lon": "${locationData.longitude}"
        },
        TokenManager().accessToken);
    print(jsonDecode(utf8.decode(response.bodyBytes)));
    final jsonData = jsonDecode(response.body);
    if (jsonData['success']) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      yesornoDialog(
        context,
        "명함 수신 완료",
        "당신도 명함을 보내시겠습니까?",
        () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false, // 배경이 투명해야 함을 나타냅니다
              pageBuilder: (BuildContext context, _, __) {
                return TransferLoadingPage();
              },
            ),
          );
          transferReverse(namecardBSeq, namecardASeq);
        },
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1),
      );
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('명함 수신 완료'),
      //       content: Text('당신도 명함을 보내시겠습니까?'),
      //       actions: [
      //         TextButton(
      //           onPressed: () async {
      //             Navigator.pop(context, '아니요');
      //             Navigator.of(context).pushNamedAndRemoveUntil(
      //                 "/main", (route) => false,
      //                 arguments: 1);
      //           },
      //           child: Text('아니요'),
      //         ),
      //         TextButton(
      //           onPressed: () async {
      //             Navigator.pop(context, '네');
      //             Navigator.of(context).push(
      //               PageRouteBuilder(
      //                 opaque: false, // 배경이 투명해야 함을 나타냅니다
      //                 pageBuilder: (BuildContext context, _, __) {
      //                   return TransferLoadingPage();
      //                 },
      //               ),
      //             );
      //             transferReverse(namecardBSeq, namecardASeq);
      //           },
      //           child: Text('네'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else {
      // ignore: use_build_context_synchronously
      showSuccessDialog(
        context,
        "전송 실패",
        "교환을 한 상대입니다",
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1),
      );
      throw Exception('Failed to load');
    }
  }

  void transferReverse(int namecardASeq, int namecardBSeq) async {
    LocationData locationData = await location.getLocation();
    final response = await apiService.postRequest(
        'namecard-service/exchange/single',
        {
          "namecardASeq": "$namecardASeq",
          "namecardBSeq": "$namecardBSeq",
          "lat": "${locationData.latitude}",
          "lon": "${locationData.longitude}"
        },
        TokenManager().accessToken);
    print(jsonDecode(utf8.decode(response.bodyBytes)));
    final jsonData = jsonDecode(response.body);
    if (jsonData['success']) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      showSuccessDialog(
        context,
        "명함 교환 완료",
        "명함 교환이 완료 되었습니다",
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1),
      );
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('명함 교환 완료'),
      //       // content: Text('당신도 명함을 보내시겠습니까?'),
      //       actions: [
      //         // TextButton(
      //         //   onPressed: () async {
      //         //     transfer(namecardBSeq, namecardASeq);
      //         //   },
      //         //   child: Text('네'),
      //         // ),
      //         TextButton(
      //           onPressed: () async {
      //             Navigator.pop(context, '닫기');
      //             Navigator.of(context).pushNamedAndRemoveUntil(
      //                 "/main", (route) => false,
      //                 arguments: 1);
      //           },
      //           child: Text('닫기'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else {
      // ignore: use_build_context_synchronously
      showSuccessDialog(
        context,
        "전송 실패",
        jsonData['error']['message'],
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1),
      );
      throw Exception('Failed to load');
    }
  }

  late AnimationController animationController;

  void start() {
    animationController.repeat();
  }

  void stop() {
    animationController.stop();
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.nearbyWifiDevices
    ].request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myNamecardItem = ModalRoute.of(context)!.settings.arguments as MyNameCard;
    print(myNamecardItem.namecardName);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "명함 받기",
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      // extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.1),
          RippleWave(
            color: Color(0xFFC9FFB6),
            repeat: false,
            animationController: animationController,
            child: Image.asset(
              'assets/card_receive.png',
              width: 160,
            ),
          ),
          // Text(
          //   "User: ${myNamecardItem.namecardName}",
          //   style: TextStyle(color: Colors.white),
          // ),
          SizedBox(height: screenHeight * 0.01),
          if (!scanning)
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    start();
                    pointClear();
                    scanningStart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black45,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pan_tool,
                        size: 22,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Text(
                          "명함 받기",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    "※ 버튼을 눌러 주변의 명함 전송과 통신하여 명함을 밭을 수 있어요",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          Container(
            height: screenHeight * 0.4,
            color: Color.fromARGB(255, 24, 24, 24),
            child: Column(
              children: discoveredEndpoints.map((endpoint) {
                return ListTile(
                  title: Text("${endpoint.name}님 발견!",
                      style: TextStyle(fontSize: 19, color: Colors.white)),
                  // subtitle: Text("ID: ${endpoint.id}",
                  //     style: TextStyle(fontSize: 14, color: Colors.white)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      // 선택한 디바이스에 대한 추가 동작 수행
                      Nearby().requestConnection(
                        myNamecardItem.namecardName,
                        endpoint.id,
                        onConnectionInitiated: (id, info) {
                          onConnectionInit(id, info);
                        },
                        onConnectionResult: (id, status) {
                          // showSuccessDialog(
                          //   context,
                          //   "전송 실패",
                          //   "거절로 인해 전송에 실패 했습니다.",
                          //   () => Navigator.of(context).pushNamedAndRemoveUntil(
                          //       "/main", (route) => false,
                          //       arguments: 1),
                          // );
                          // showSnackbar("뭘봐");
                          // showSnackbar(status);
                        },
                        onDisconnected: (id) {
                          setState(() {
                            endpointMap.remove(id);
                          });
                          // showSnackbar(
                          //     "Disconnected from: ${endpoint.name}, id $id");
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00ADEF),
                    ),
                    child: Text(
                      "명함 요청",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // ElevatedButton(
          //   child: const Text("명함 전송"),
          //   onPressed: () async {
          //     endpointMap.forEach((key, value) {
          //       String a = Random().nextInt(100).toString();

          //       showSnackbar(
          //           " ${value.endpointName} 에게 $a 라는 데이터 보내요 ~~ , id: $key");
          //       Nearby().sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        a.toString(),
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: Color(0xFF00496F),
    ));
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (builder) {
        return SizedBox(
          height: screenHeight * 0.3,
          child: Center(
            child: Column(
              children: <Widget>[
                // Text("id: $id"),
                // Text("Token: ${info.authenticationToken}"),
                // Text("Name${info.endpointName}"),
                // Text("Incoming: ${info.isIncomingConnection}"),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "${info.endpointName}님께 요청을 보냈습니다",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "명함을 받기 위해 연결 하시겠습니까?",
                  style: TextStyle(fontSize: 20, color: Color(0xFF00496F)),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06),
                          child: button(
                            "취소",
                            () async {
                              Navigator.pop(context);
                              try {
                                await Nearby().rejectConnection(id);
                              } catch (e) {
                                print(e);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06),
                          child: button(
                            "연결",
                            () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false, // 배경이 투명해야 함을 나타냅니다
                                  pageBuilder: (BuildContext context, _, __) {
                                    return TransferLoadingPage();
                                  },
                                ),
                              );
                              setState(() {
                                endpointMap[id] = info;
                              });
                              Nearby().acceptConnection(
                                // acceptConnection : 수락하고 데이터를 주고 받기 위한 기능 제공
                                id,
                                onPayLoadRecieved: (endid, payload) async {
                                  // onPayLoadRecieved : 연결된 디바이스로부터 데이터를 수신했을때 호출
                                  if (payload.type == PayloadType.BYTES) {
                                    String str = String.fromCharCodes(
                                        payload.bytes!); // 바이트 데이터를 문자열로 반환
                                    // showSnackbar("$endid: $str");
                                    int seq = int.parse(str);
                                    print(
                                        "namecardSeqA :  ${myNamecardItem.namecardSeq} , namecardSeqB : $seq");
                                    transfer(myNamecardItem.namecardSeq, seq);

                                    // 모달을 띄워서 너도 보낼래????? 해줌
                                    // 확인 누르면 나도 보내는 api 호출
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget button(
    title,
    onPressed,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(screenWidth * 0.3, screenHeight * 0.06),
        backgroundColor: Color(0xFF00ADEF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
