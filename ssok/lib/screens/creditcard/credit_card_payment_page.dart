import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
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
  bool _isNFC = false;
  bool _isPaymentDone = false;
  ValueNotifier<dynamic> result = ValueNotifier(null);
  ApiService apiService = ApiService();






  Future<bool> _authenticateWithBiometrics() async {
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
        return true;
      }
      print("com here ?");
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
        authenticated = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return false;
    }
    if (!mounted) {
      return false;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
    Navigator.of(context).pop();  
    return false;  
  }

  check() async {
    bool isLocalAuth;
    isLocalAuth = await LocalAuthentication().canCheckBiometrics;
    setState(() {
      authenticated = true;
      _isLocalAuth = isLocalAuth;
    });
    if (_isLocalAuth) {
      print("할 수 있음");
    } else {
      print("할 수 없음");
    }
    Future<bool> biometricsFlag = _authenticateWithBiometrics();
    biometricsFlag.then((bool isAuthenticated){
      if(isAuthenticated){
        Future<bool> NFCFlag = checkNFCAvailability();
        NFCFlag.then((bool isNFCAvailable){
          if(isNFCAvailable){
            _tagRead();
          }
        });
      }
      
      
    });
    



    // bool isAvailable = await NfcManager.instance.isAvailable();
    // print("됩니까? ${isAvailable}");

    // // Start Session
    // NfcManager.instance.startSession(
    //   onDiscovered: (NfcTag tag) async {
    //     // Do something with an NfcTag instance.
    //   },
    // );
  }

  void send () async {
    final response = apiService.postRequest("pos/payment-service/payment", {}, TokenManager().accessToken);
  }
  
  void _tagRead() {
    checkNFCAvailability();
    print("1231232131");
    
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef != null) {
      final NdefMessage message = await ndef.read();
      if (message.records.isNotEmpty) {
        final NdefRecord record = message.records.first;
        // 여기에서 원하는 데이터를 추출할 수 있습니다.
        // 이 예시에서는 텍스트 레코드를 가정합니다.
        String textData = String.fromCharCodes(record.payload).substring(3);
        print("@@@@@@@@@@@@@@@@@@읽을게");
        print(textData);
        parsing(textData);
      }
    }
      setState(() {
              _isPaymentDone = true;
            });
      result.value = tag.data;
      print("nfc 결과입니다");
      print(result.value);
      
      NfcManager.instance.stopSession();
    });
  }
  
  void parsing(String data) {
    // 데이터 분할
  List<String> parts = data.split(' / ');

  // 변수 초기화
  String? amount;
  List<Map<String, dynamic>> paymentItemList = [];
  String? key;

  // 분할된 데이터를 변수에 할당
  for (String part in parts) {
    List<String> keyValue = part.split(':');
    String currentKey = keyValue[0];
    String value = keyValue[1];

    if (currentKey == 'amount') {
      amount = value;
    } else if (currentKey == 'itemSeq') {
      List<String> itemSeqList = value.split(',');
      List<String> itemCntList = parts.firstWhere((p) => p.startsWith('itemCnt:')).split(':')[1].split(',');

      for (int i = 0; i < itemSeqList.length; i++) {
        int itemSeq = int.parse(itemSeqList[i]);
        int itemCnt = int.parse(itemCntList[i]);

        paymentItemList.add({
          'itemSeq': itemSeq,
          'itemCnt': itemCnt,
        });
      }
    } else if (currentKey == 'key') {
      key = value;
    }
    // 결과 출력
  }
  // key가 'ssok'인지 체크
  if (key != 'ssok') {
    print('Invalid key. Returning false.');
    return;
  }


  
  // 결과 출력
  print('amount: $amount');
  print('paymentItemList: $paymentItemList');
  }



  Future<bool> checkNFCAvailability() async{
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
                onPressed: () async {
                  // Navigator.pop(context);
                  await AppSettings.openAppSettings(type: AppSettingsType.nfc);
                  // await AppSettings.openAppSettings(type:AppSettingsType.nfc);
                  // Navigator.pop(context);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("설정 "),
              ),
              TextButton(
                onPressed: () { 
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  },
                child: Text("확인"),
              ),
            ],
          ),
        );
      return false;
      // throw "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.";
      
    }else{
      setState(() {
        _isNFC = true;
      });
      print("good");
      return true;
    }
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
  
  void _ndefWrite() {
    
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      print("d@!@!@!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        print(result.value);
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
    // _authenticateWithBiometrics();
    // checkNFCAvailability();
    //                                                                                                                                                        _ndefWrite();    
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
            authenticated && !_isNFC ? "NFC 기능을 켜주세요." : authenticated && _isNFC && !_isPaymentDone ? "디바이스의 뒷면을 리더기에 대세요" : "결제 중",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          if (authenticated && _isNFC)
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white), // 프로그레스 바 색상
            ),
        ],
      ),
    );
  }
}
