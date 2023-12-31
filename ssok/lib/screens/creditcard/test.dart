// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:app_settings/app_settings.dart';

// class Test extends StatefulWidget {
//   const Test({super.key});

//   @override
//   State<Test> createState() => _TestState();
// }


// class _AndroidSessionDialog extends StatefulWidget {
//   const _AndroidSessionDialog(this.alertMessage, this.handleTag);

//   final String alertMessage;

//   final String Function(NfcTag tag) handleTag;

//   @override
//   State<StatefulWidget> createState() => _AndroidSessionDialogState();
// }

// class _AndroidSessionDialogState extends State<_AndroidSessionDialog> {
//   String? _alertMessage;
//   String? _errorMessage;

//   String? _result;

//   @override
//   void initState() {
//     super.initState();

//     NfcManager.instance.startSession(
//       onDiscovered: (NfcTag tag) async {
//         try {
//           _result = widget.handleTag(tag);

//           await NfcManager.instance.stopSession();

//           setState(() => _alertMessage = "NFC 태그를 인식하였습니다.");
//         } catch (e) {
//           await NfcManager.instance.stopSession();

//           setState(() => _errorMessage = '$e');
//         }
//       },
//     ).catchError((e) => setState(() => _errorMessage = '$e'));
//   }

//   @override
//   void dispose() {
//     NfcManager.instance.stopSession();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         _errorMessage?.isNotEmpty == true
//             ? "오류"
//             : _alertMessage?.isNotEmpty == true
//                 ? "성공"
//                 : "준비",
//       ),
//       content: Text(
//         _errorMessage?.isNotEmpty == true
//             ? _errorMessage!
//             : _alertMessage?.isNotEmpty == true
//                 ? _alertMessage!
//                 : widget.alertMessage,
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Text(
//               _errorMessage?.isNotEmpty == true
//                   ? "확인"
//                   : _alertMessage?.isNotEmpty == true
//                       ? "완료"
//                       : "취소",
//               style: TextStyle(color: Colors.black)),
//           onPressed: () => Navigator.of(context).pop(_result),
//         ),
//       ],
//     );
//   }
// }

// String _handleTag(NfcTag tag) {
//     try {
//       final List<int> tempIntList;
//         tempIntList =
//             List<int>.from(Ndef.from(tag)?.additionalData["identifier"]);
    
//       String id = "";

//       tempIntList.forEach((element) {
//         id = id + element.toRadixString(16);
//       });

//       return id;
//     } catch (e) {
//       throw "NFC 데이터를 가져올 수 없습니다.";
//     }
//   }


// class _TestState extends State<Test> {
//   late FlutterBlue flutterBlue;
//   // BluetoothDevice? _targetDevice;
//   // BluetoothCharacteristic? _txCharacteristic; // 데이터 송신용 캐릭터리스틱
//   // BluetoothCharacteristic? _rxCharacteristic; // 데이터 수신용 캐릭터리스틱
//   // TextEditingController _inputController = TextEditingController();
//   // List<String> _receivedMessages = [];

//   @override
//   void initState() {
//     super.initState();
//     flutterBlue = FlutterBlue.instance;
//     _scan();

//     // 대상 Bluetooth 장치를 찾기 위한 스캐닝 시작
//   }

//   Future<void> _scan() async {
//     flutterBlue.startScan(timeout: Duration(seconds: 4));
//     var subscription = await flutterBlue.scanResults.listen((results) {
//       for (ScanResult r in results) {
//         print('${r.device.name} found! rssi: ${r.rssi}');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Data Transfer (Two-Way)'),
//       ),
//       body: Text("a"),
//       // body: Center(
//       //   child: Column(
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: <Widget>[
//       //       if (_targetDevice != null)
//       //         Text('Connected to: ${_targetDevice!.name}'),
//       //       TextField(
//       //         controller: _inputController,
//       //         decoration: InputDecoration(labelText: 'Enter Message'),
//       //       ),
//       //       ElevatedButton(
//       //         onPressed: _sendData,
//       //         child: Text('Send Data'),
//       //       ),
//       //       Divider(),
//       //       Text('Received Messages:'),
//       //       for (String message in _receivedMessages) Text(message),
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }





// // import 'dart:typed_data';

// // import 'package:flutter/material.dart';
// // import 'package:nfc_manager/nfc_manager.dart';

// // class Test extends StatefulWidget {
// //   const Test({super.key});

// //   @override
// //   State<Test> createState() => _TestState();
// // }

// // class _TestState extends State<Test> {
// //   ValueNotifier<dynamic> result = ValueNotifier(null);
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(title: Text('NfcManager Plugin Example')),
// //         body: SafeArea(
// //           child: FutureBuilder<bool>(
// //             future: NfcManager.instance.isAvailable(),
// //             builder: (context, ss) => ss.data != true
// //                 ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
// //                 : Flex(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     direction: Axis.vertical,
// //                     children: [
// //                       Flexible(
// //                         flex: 2,
// //                         child: Container(
// //                           margin: EdgeInsets.all(4),
// //                           constraints: BoxConstraints.expand(),
// //                           decoration: BoxDecoration(border: Border.all()),
// //                           child: SingleChildScrollView(
// //                             child: ValueListenableBuilder<dynamic>(
// //                               valueListenable: result,
// //                               builder: (context, value, _) =>
// //                                   Text('${value ?? ''}'),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       Flexible(
// //                         flex: 3,
// //                         child: GridView.count(
// //                           padding: EdgeInsets.all(4),
// //                           crossAxisCount: 2,
// //                           childAspectRatio: 4,
// //                           crossAxisSpacing: 4,
// //                           mainAxisSpacing: 4,
// //                           children: [
// //                             ElevatedButton(
// //                                 child: Text('Tag Read'), onPressed: _tagRead),
// //                             ElevatedButton(
// //                                 child: Text('Ndef Write'),
// //                                 onPressed: _ndefWrite),
// //                             ElevatedButton(
// //                                 child: Text('Ndef Write Lock'),
// //                                 onPressed: _ndefWriteLock),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void _tagRead() {
// //     print("읽어");
// //     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
// //       result.value = tag.data;
// //       NfcManager.instance.stopSession();
// //     });
// //   }

// //   void _ndefWrite() {
// //     print("써");
// //     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
// //       print("쓸께요");
// //       var ndef = Ndef.from(tag);
// //       print(ndef.toString());
// //       if (ndef == null || !ndef.isWritable) {
// //         result.value = 'Tag is not ndef writable';
// //         NfcManager.instance.stopSession(errorMessage: result.value);
// //         return;
// //       }

// //       NdefMessage message = NdefMessage([
// //         NdefRecord.createText('Hello World!'),
// //         NdefRecord.createUri(Uri.parse('https://flutter.dev')),
// //         NdefRecord.createMime(
// //             'text/plain', Uint8List.fromList('Hello'.codeUnits)),
// //         NdefRecord.createExternal(
// //             'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits)),
// //       ]);

// //       try {
// //         await ndef.write(message);
// //         result.value = 'Success to "Ndef Write"';
// //         NfcManager.instance.stopSession();
// //       } catch (e) {
// //         result.value = e;
// //         NfcManager.instance.stopSession(errorMessage: result.value.toString());
// //         return;
// //       }
// //     });
// //   }

// //   void _ndefWriteLock() {
// //     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
// //       var ndef = Ndef.from(tag);
// //       if (ndef == null) {
// //         result.value = 'Tag is not ndef';
// //         NfcManager.instance.stopSession(errorMessage: result.value.toString());
// //         return;
// //       }

// //       try {
// //         await ndef.writeLock();
// //         result.value = 'Success to "Ndef Write Lock"';
// //         NfcManager.instance.stopSession();
// //       } catch (e) {
// //         result.value = e;
// //         NfcManager.instance.stopSession(errorMessage: result.value.toString());
// //         return;
// //       }
// //     });
// //   }
// // }
