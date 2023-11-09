import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

class BusinessCardSendBlueToothPage extends StatefulWidget {
  const BusinessCardSendBlueToothPage({super.key});

  @override
  State<BusinessCardSendBlueToothPage> createState() =>
      _BusinessCardSendBlueToothPageState();
}

class _BusinessCardSendBlueToothPageState
    extends State<BusinessCardSendBlueToothPage> {
  ApiService apiService = ApiService();
  final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};
  String? tempFileUri;
  Map<int, String> map = {};
  bool advertising = false;
  bool scanning = false;
  late int namecardSeq;

  void scanningStart() async {
    try {
      bool a = await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          // show sheet automatically to request connection
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Text("id: $id"),
                    Text("Name: $name"),
                    Text("ServiceId: $serviceId"),
                    ElevatedButton(
                      child: const Text("Request Connection"),
                      onPressed: () {
                        Navigator.pop(context);
                        Nearby().requestConnection(
                          userName,
                          id,
                          onConnectionInitiated: (id, info) {
                            onConnectionInit(id, info);
                          },
                          onConnectionResult: (id, status) {
                            showSnackbar(status);
                          },
                          onDisconnected: (id) {
                            setState(() {
                              endpointMap.remove(id);
                            });
                            showSnackbar(
                                "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        onEndpointLost: (id) {
          showSnackbar(
              "Lost discovered Endpoint: ${endpointMap[id]?.endpointName}, id $id");
        },
      );
      showSnackbar("DISCOVERING: $a");
      setState(() {
        scanning = true;
      });
    } catch (e) {
      showSnackbar(e);
    }
    Future.delayed(const Duration(milliseconds: 10000), () async {
      await Nearby().stopDiscovery();
      pointClear();
      setState(() {
        scanning = false;
      });
    });
  }

  void pointClear() async {
    await Nearby().stopAllEndpoints();
    setState(() {
      endpointMap.clear();
    });
  }

  void transfer(int namecardASeq, int namecardBSeq) async {
    print("전송 시작!!!");
    final response = await apiService.postRequest(
        'namecard-service/exchange/single',
        {
          "namecardASeq": "$namecardASeq",
          "namecardBSeq": "$namecardBSeq",
          "lat": "35.193844",
          "lon": "126.8102029"
        },
        TokenManager().accessToken);
    print("전송 끝!!!");
    print(jsonDecode(utf8.decode(response.bodyBytes)));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print("전송 성공!!!");
    } else {
      print("전송 실패!!!");
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    namecardSeq = ModalRoute.of(context)!.settings.arguments as int;
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
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              child: Container(
                width: 200,
                height: 400,
                color: Colors.amber,
              )),
          SizedBox(height: screenHeight * 0.04),
          Text(
            "User Name: $namecardSeq",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: screenHeight * 0.01),
          ElevatedButton(
            onPressed: () {
              pointClear();
              scanningStart();
            },
            child: Text(scanning ? "스캔 중" : "스캔 시작"),
          ),
          SizedBox(
            height: screenHeight * 0.025,
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
      content: Text(a.toString()),
    ));
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              Text("id: $id"),
              Text("Token: ${info.authenticationToken}"),
              Text("Name${info.endpointName}"),
              Text("Incoming: ${info.isIncomingConnection}"),
              ElevatedButton(
                child: const Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
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
                        showSnackbar("$endid: $str");
                        int seq = int.parse(str);
                        print(
                            "namecardSeqA :  $namecardSeq , namecardSeqB : $seq");

                        transfer(namecardSeq, seq);
                      }
                    },
                    // onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                    //   if (payloadTransferUpdate
                    //           .status == // 상태 == IN_PROGRESS인 경우 전송 중인 데이터 양 등을 업데이트
                    //       PayloadStatus.IN_PROGRESS) {
                    //     print(
                    //         "${payloadTransferUpdate.bytesTransferred} 여긴가??");
                    //   } else if (payloadTransferUpdate.status ==
                    //       PayloadStatus.FAILURE) {
                    //     // 상태 == FAILURE인 경우  전송 실패에 대한 처리를 수행
                    //     print("failed");
                    //     showSnackbar("$endid: FAILED to transfer file");
                    //   } else if (payloadTransferUpdate
                    //           .status == // 상태 == SUCCESS 전송이 성공적으로 완료되었을 때 처리를 수행
                    //       PayloadStatus.SUCCESS) {
                    //     // transfer(namecardSeq, payloadTransferUpdate.totalBytes);
                    //     print("ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ");
                    //     print(payloadTransferUpdate.totalBytes);
                    //     showSnackbar(
                    //         "$endid  ${payloadTransferUpdate.totalBytes} 명함 받기에 성공했어요! 너도 보낼래?");
                    //   }
                    // },
                  );
                },
              ),
              ElevatedButton(
                child: const Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
