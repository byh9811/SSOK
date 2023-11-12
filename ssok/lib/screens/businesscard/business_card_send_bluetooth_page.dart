import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ssok/dto/business_card_data.dart';

class BusinessCardSendBluetoothPage extends StatefulWidget {
  const BusinessCardSendBluetoothPage({super.key});

  @override
  State<BusinessCardSendBluetoothPage> createState() =>
      _BusinessCardSendBluetoothPageState();
}

class _BusinessCardSendBluetoothPageState
    extends State<BusinessCardSendBluetoothPage> {
  // final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};
  String? tempFileUri;
  Map<int, String> map = {};
  bool advertising = false;
  bool scanning = false;
  late MyNameCard myNamecardItem;

  @override
  void initState() {
    super.initState();
    [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request();
  }

  void advertisingStart() async {
    try {
      bool a = await Nearby().startAdvertising(
        myNamecardItem.namecardName,
        strategy,
        onConnectionInitiated: onConnectionInit,
        onConnectionResult: (id, status) {
          showSnackbar(status);
          sendBusinessCard(myNamecardItem.namecardSeq);
        },
        onDisconnected: (id) {
          showSnackbar(
              "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
          setState(() {
            endpointMap.remove(id);
          });
        },
      );
      showSnackbar("어필 : $a");
      setState(() {
        advertising = true;
      });
      Future.delayed(const Duration(milliseconds: 10000), () async {
        await Nearby().stopAdvertising();
        // pointClear();
        setState(() {
          advertising = false;
        });
      });
    } catch (exception) {
      showSnackbar(exception);
    }
  }

  void sendBusinessCard(int myNamecardSeq) {
    endpointMap.forEach((key, value) {
      String myNamecardSeqString = myNamecardSeq.toString();

      showSnackbar(
          " ${value.endpointName} $myNamecardSeqString이 ~에게 명함을 보내요 ~~ , id: $key");
      Nearby().sendBytesPayload(
          key, Uint8List.fromList(myNamecardSeqString.codeUnits));
    });
  }

  // void scanningStart() async {
  //   try {
  //     bool a = await Nearby().startDiscovery(
  //       userName,
  //       strategy,
  //       onEndpointFound: (id, name, serviceId) {
  //         // show sheet automatically to request connection
  //         showModalBottomSheet(
  //           context: context,
  //           builder: (builder) {
  //             return Center(
  //               child: Column(
  //                 children: <Widget>[
  //                   Text("id: $id"),
  //                   Text("Name: $name"),
  //                   Text("ServiceId: $serviceId"),
  //                   ElevatedButton(
  //                     child: const Text("Request Connection"),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                       Nearby().requestConnection(
  //                         userName,
  //                         id,
  //                         onConnectionInitiated: (id, info) {
  //                           onConnectionInit(id, info);
  //                         },
  //                         onConnectionResult: (id, status) {
  //                           showSnackbar(status);
  //                         },
  //                         onDisconnected: (id) {
  //                           setState(() {
  //                             endpointMap.remove(id);
  //                           });
  //                           showSnackbar(
  //                               "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
  //                         },
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       },
  //       onEndpointLost: (id) {
  //         showSnackbar(
  //             "Lost discovered Endpoint: ${endpointMap[id]?.endpointName}, id $id");
  //       },
  //     );
  //     showSnackbar("DISCOVERING: $a");
  //     setState(() {
  //       scanning = true;
  //     });
  //   } catch (e) {
  //     showSnackbar(e);
  //   }
  //   Future.delayed(const Duration(milliseconds: 10000), () async {
  //     await Nearby().stopDiscovery();
  //     pointClear();
  //     setState(() {
  //       scanning = false;
  //     });
  //   });
  // }

  void pointClear() async {
    await Nearby().stopAllEndpoints();
    setState(() {
      endpointMap.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    myNamecardItem = ModalRoute.of(context)!.settings.arguments as MyNameCard;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "명함 전송",
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
            "User : ${myNamecardItem.namecardName}",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: screenHeight * 0.01),
          ElevatedButton(
            onPressed: () {
              pointClear();
              advertisingStart();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00ADEF),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.radar,
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Text(advertising ? "어필 중" : "어필시작"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          SizedBox(
            height: screenHeight * 0.025,
          ),
          ElevatedButton(
            child: const Text("명함 전송"),
            onPressed: () async {
              sendBusinessCard(myNamecardItem.namecardSeq);
            },
          ),
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
    double screenWidth = MediaQuery.of(context).size.width;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    child: button(
                      "수락",
                      () {
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
                            }
                          },
                          onPayloadTransferUpdate:
                              (endid, payloadTransferUpdate) {
                            if (payloadTransferUpdate
                                    .status == // 상태 == IN_PROGRESS인 경우 전송 중인 데이터 양 등을 업데이트
                                PayloadStatus.IN_PROGRESS) {
                              print(payloadTransferUpdate.bytesTransferred);
                            } else if (payloadTransferUpdate.status ==
                                PayloadStatus.FAILURE) {
                              // 상태 == FAILURE인 경우  전송 실패에 대한 처리를 수행
                              print("failed");
                              showSnackbar("$endid 명함 전송 실패");
                            } else if (payloadTransferUpdate
                                    .status == // 상태 == SUCCESS 전송이 성공적으로 완료되었을 때 처리를 수행
                                PayloadStatus.SUCCESS) {
                              showSnackbar(
                                  "$endid 명함 전송 성공 = ${payloadTransferUpdate.totalBytes}");
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    child: button(
                      "거절",
                      () async {
                        Navigator.pop(context);
                        try {
                          await Nearby().rejectConnection(id);
                        } catch (e) {
                          showSnackbar(e);
                        }
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                child: const Text("Accept Connection"),
                onPressed: () {},
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
