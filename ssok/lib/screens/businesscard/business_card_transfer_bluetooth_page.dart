import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

class BusinessCardTransferBluetoothPage extends StatefulWidget {
  const BusinessCardTransferBluetoothPage({super.key});

  @override
  State<BusinessCardTransferBluetoothPage> createState() =>
      _BusinessCardTransferBluetoothPageState();
}

class _BusinessCardTransferBluetoothPageState
    extends State<BusinessCardTransferBluetoothPage> {
  final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};
  String? tempFileUri;
  Map<int, String> map = {};
  bool advertising = false;
  bool scanning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "명함 교환",
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
            "User Name: $userName",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: screenHeight * 0.01),
          ElevatedButton(
            onPressed: () async {
              try {
                bool a = await Nearby().startAdvertising(
                  userName,
                  strategy,
                  onConnectionInitiated: onConnectionInit,
                  onConnectionResult: (id, status) {
                    showSnackbar(status);
                  },
                  onDisconnected: (id) {
                    showSnackbar(
                        "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
                    setState(() {
                      endpointMap.remove(id);
                    });
                  },
                );
                showSnackbar("ADVERTISING: $a");
                setState(() {
                  advertising = true;
                });
                Future.delayed(const Duration(milliseconds: 2000), () async {
                  await Nearby().stopAdvertising();
                  setState(() {
                    advertising = false;
                  });
                });
              } catch (exception) {
                showSnackbar(exception);
              }
            },
            child: Text(advertising ? "어필 중" : "어필시작"),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          ElevatedButton(
            onPressed: () async {
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
              Future.delayed(const Duration(milliseconds: 4000), () async {
                await Nearby().stopDiscovery();
                setState(() {
                  scanning = false;
                });
              });
            },
            child: Text(scanning ? "스캔 중" : "스캔 시작"),
          ),
          SizedBox(
            height: screenHeight * 0.025,
          ),
          ElevatedButton(
            child: const Text("랜덤 숫자 보내기"),
            onPressed: () async {
              endpointMap.forEach((key, value) {
                String a = Random().nextInt(100).toString();

                showSnackbar(
                    " ${value.endpointName} 에게 $a 라는 데이터 보내요 ~~ , id: $key");
                Nearby().sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
              });
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

  // Future<bool> moveFile(String uri, String fileName) async {
  //   String parentDir = (await getExternalStorageDirectory())!.absolute.path;
  //   final b =
  //       await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

  //   showSnackbar("Moved file:$b");
  //   return b;
  // }

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

                        // if (str.contains(':')) {
                        //   // used for file payload as file payload is mapped as
                        //   // payloadId:filename
                        //   int payloadId = int.parse(str.split(':')[0]);
                        //   String fileName = (str.split(':')[1]);

                        //   if (map.containsKey(payloadId)) {
                        //     if (tempFileUri != null) {
                        //       moveFile(tempFileUri!, fileName);
                        //     } else {
                        //       showSnackbar("File doesn't exist");
                        //     }
                        //   } else {
                        //     //add to map if not already
                        //     map[payloadId] = fileName;
                        //   }
                        // }
                      }
                      // } else if (payload.type == PayloadType.FILE) {
                      //   showSnackbar("$endid: File transfer started");
                      //   tempFileUri = payload.uri;
                      // }
                    },
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate
                              .status == // 상태 == IN_PROGRESS인 경우 전송 중인 데이터 양 등을 업데이트
                          PayloadStatus.IN_PROGRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        // 상태 == FAILURE인 경우  전송 실패에 대한 처리를 수행
                        print("failed");
                        showSnackbar("$endid: FAILED to transfer file");
                      } else if (payloadTransferUpdate
                              .status == // 상태 == SUCCESS 전송이 성공적으로 완료되었을 때 처리를 수행
                          PayloadStatus.SUCCESS) {
                        showSnackbar(
                            "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

                        // if (map.containsKey(payloadTransferUpdate.id)) {
                        //   //rename the file now
                        //   String name = map[payloadTransferUpdate.id]!;
                        //   moveFile(tempFileUri!, name);
                        // } else {
                        //   //bytes not received till yet
                        //   map[payloadTransferUpdate.id] = "";
                        // }
                      }
                    },
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
