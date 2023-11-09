import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:app_settings/app_settings.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}


class _AndroidSessionDialog extends StatefulWidget {
  const _AndroidSessionDialog(this.alertMessage, this.handleTag);

  final String alertMessage;

  final String Function(NfcTag tag) handleTag;

  @override
  State<StatefulWidget> createState() => _AndroidSessionDialogState();
}

class _AndroidSessionDialogState extends State<_AndroidSessionDialog> {
  String? _alertMessage;
  String? _errorMessage;

  String? _result;

  @override
  void initState() {
    super.initState();

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        try {
          _result = widget.handleTag(tag);

          await NfcManager.instance.stopSession();

          setState(() => _alertMessage = "NFC 태그를 인식하였습니다.");
        } catch (e) {
          await NfcManager.instance.stopSession();

          setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => setState(() => _errorMessage = '$e'));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _errorMessage?.isNotEmpty == true
            ? "오류"
            : _alertMessage?.isNotEmpty == true
                ? "성공"
                : "준비",
      ),
      content: Text(
        _errorMessage?.isNotEmpty == true
            ? _errorMessage!
            : _alertMessage?.isNotEmpty == true
                ? _alertMessage!
                : widget.alertMessage,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
              _errorMessage?.isNotEmpty == true
                  ? "확인"
                  : _alertMessage?.isNotEmpty == true
                      ? "완료"
                      : "취소",
              style: TextStyle(color: Colors.black)),
          onPressed: () => Navigator.of(context).pop(_result),
        ),
      ],
    );
  }
}

String _handleTag(NfcTag tag) {
    try {
      final List<int> tempIntList;
        tempIntList =
            List<int>.from(Ndef.from(tag)?.additionalData["identifier"]);
    
      String id = "";

      tempIntList.forEach((element) {
        id = id + element.toRadixString(16);
      });

      return id;
    } catch (e) {
      throw "NFC 데이터를 가져올 수 없습니다.";
    }
  }


class _TestState extends State<Test> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('NfcManager Plugin Example')),
        body: SafeArea(
          // child: FutureBuilder<bool>(
          //   future: NfcManager.instance.isAvailable(),
          //   builder: (context, ss) => ss.data != true
          //       ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
                 
                 child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(4),
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(border: Border.all()),
                          child: SingleChildScrollView(
                            child: ValueListenableBuilder<dynamic>(
                              valueListenable: result,
                              builder: (context, value, _) =>
                                  Text('${value ?? ''}'),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: GridView.count(
                          padding: EdgeInsets.all(4),
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          children: [
                            ElevatedButton(
                                child: Text('Tag Read'), onPressed: _tagRead),
                            ElevatedButton(
                                child: Text('Ndef Write'),
                                onPressed: _ndefWrite),
                            ElevatedButton(
                                child: Text('Ndef Write Lock'),
                                onPressed: _ndefWriteLock),
                          ],
                        ),
                      ),
                    ],
                  ),
          // ),
        ),
      ),
    );
  }

  void checkNFCAvailability() async{
      print("@@?@??");
     if (!(await NfcManager.instance.isAvailable())) { 
      
        print("gege");
          // ignore: use_build_context_synchronously
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("오류"),
              content: Text(
                "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    AppSettings.openAppSettings(type: AppSettingsType.nfc);
                  },
                  child: Text("설정"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("확인"),
                ),
              ],
            ),
          );
        throw "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.";
      }else{
        print("good");
      }
    }

  void _tagRead() {
    checkNFCAvailability();
    print("1231232131");
    
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      await showDialog(
            context: context,
            builder: (context) => _AndroidSessionDialog("기기를 필터 가까이에 가져다주세요.", _handleTag),
          //   builder: (context) => AlertDialog(
          //     title: Text("오류"),
          //     content: Text(
          //       "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.",
          //       style: TextStyle(color: Colors.black, fontSize: 16),
          //     )
          // );
      );
      result.value = tag.data;
      print(result.value);
      NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText('Hello World!'),
        NdefRecord.createUri(Uri.parse('https://flutter.dev')),
        NdefRecord.createMime(
            'text/plain', Uint8List.fromList('Hello'.codeUnits)),
        NdefRecord.createExternal(
            'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  void _ndefWriteLock() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = 'Tag is not ndef';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      try {
        await ndef.writeLock();
        result.value = 'Success to "Ndef Write Lock"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}
