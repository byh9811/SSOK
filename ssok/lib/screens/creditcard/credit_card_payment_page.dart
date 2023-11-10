import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ssok/widgets/creditcards/childrens/my_credit_card.dart';
import 'package:local_auth/local_auth.dart';
import 'package:app_settings/app_settings.dart';

class CreditCardPaymentPage extends StatefulWidget {
  const CreditCardPaymentPage({super.key});

  @override
  State<CreditCardPaymentPage> createState() => _CreditCardPaymentPageState();
}



class _CreditCardPaymentPageState extends State<CreditCardPaymentPage> {
  late final LocalAuthentication auth;
  late bool _isLocalAuth;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  bool authenticated = false;
  bool _isNfc = false;
  ValueNotifier<dynamic> result = ValueNotifier(null);
  

  Future<void>                                                                                                                                                                                              _authenticateWithBiometrics() async {
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: '지문을 스캔 해주세요.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        print("지문 일치");
      } else {
        print("지문 불일치");
        Navigator.of(context).pop();
      }
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  check() async {
    bool isLocalAuth;
    isLocalAuth = await LocalAuthentication().canCheckBiometrics;
    setState(() {
      _isLocalAuth = isLocalAuth;
    });
    if (_isLocalAuth) {
      print("할 수 있음");
    } else {
      print("할 수 없음");
    }
    // bool isAvailable = await NfcManager.instance.isAvailable();
    // print("됩니까? ${isAvailable}");

    // // Start Session
    // NfcManager.instance.startSession(
    //   onDiscovered: (NfcTag tag) async {
    //     // Do something with an NfcTag instance.
    //   },
    // );
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
        setState(() {
          
        _isNfc = true;
        });
        print("good");
      }
    }

//   void checkNFCAvailabilityAfterSettings() async {
//   print("@@?@??");
//   if (!(await NfcManager.instance.isAvailable())) {
//     print("gege");
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("오류"),
//         content: Text(
//           "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               AppSettings.openAppSettings(type: AppSettingsType.nfc);
//             },
//             child: Text("설정"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("확인"),
//           ),
//         ],
//       ),
//     );
//     throw "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.";
//   } else {
//     print("good");
//   }
// }

// void checkNFCAvailability() async {
//   try {
//     await checkNFCAvailabilityAfterSettings();
//   } catch (e) {
//     print("Error occurred: $e");
//     // Handle any errors or exceptions here
//   }
// }


//   void checkNFCAvailability({bool afterSettings = false}) async {
//   print("@@?@??");
//   bool isNfcAvailable = await NfcManager.instance.isAvailable();
//   if (!isNfcAvailable) {
//     print("gege");
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("오류"),
//         content: Text(
//           "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               AppSettings.openAppSettings(type: AppSettingsType.nfc);
//             },
//             child: Text("설정"),
//           ),
//           TextButton(
//             onPressed: afterSettings
//                 ? () => Navigator.pop(context)
//                 : () {
//                     Navigator.pop(context);
//                     checkNFCAvailability(afterSettings: true);
//                   },
//             child: Text(afterSettings ? "확인" : "취소"),
//           ),
//         ],
//       ),
//     );
//     throw "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.";
//   } else {
//     print("good");
//   }
// }
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
  
  void _ndefWrite() {
    print("들어왔단.");
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


  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    check();
    _authenticateWithBiometrics().then((_) {
      checkNFCAvailability();}).then((value) => null);
      _ndefWrite();
    // checkNFCAvailability();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var _authorized = '';
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "결제",
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
            child: MyCreditCard(
              vertical: true,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.2,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(authenticated ? '인증 완료' : '인증 안됨'),
                const Icon(Icons.fingerprint),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Text(
            // authenticated ? "결제 중" : "",
            _isNfc ? "결제 중" : "",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(                                                                                                    
            height: screenHeight * 0.01,
          ),
          // if (authenticated)
          if(_isNfc)
            CircularProgressIndicator(
              valueColor: 
                  AlwaysStoppedAnimation<Color>(Colors.white), // 프로그레스 바 색상
            ),
        ],
      ),
    );
  }
}
