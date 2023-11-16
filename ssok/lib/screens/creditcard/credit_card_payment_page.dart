import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/identification/simple_password_page.dart';
import 'package:ssok/widgets/creditcards/childrens/my_credit_card.dart';
import 'package:local_auth/local_auth.dart';
import 'package:app_settings/app_settings.dart';
import 'package:ssok/widgets/creditcards/creditcard_payment_timer.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class CreditCardPaymentPage extends StatefulWidget {
  const CreditCardPaymentPage({super.key});

  @override
  State<CreditCardPaymentPage> createState() => _CreditCardPaymentPageState();
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class PaymentItem {
  int itemSeq;
  String itemCnt;

  PaymentItem({
    required this.itemSeq,
    required this.itemCnt,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemSeq': itemSeq,
      'itemCnt': itemCnt,
    };
  }
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
  Map<String, dynamic>? args;
  CreditCardPaymentTimer te = CreditCardPaymentTimer();
  bool isPasswordMatched = false;

  bool NFCFlag = true;

  // 요청 변수
  String cardNum = "";
  String cardType = "01";
  String amount = "";
  String type = "01";
  String installPeriod = "0";
  String shopName = "ssafy-ssok";
  String shopNumber = "123-45-67890";
  List<Map<String, dynamic>> paymentItemList = [];
  // List<PaymentItem> paymentItemList = [];

  void updatePasswordMatchStatus(bool status) {
    setState(() {
      isPasswordMatched = status;
    });
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      authenticated = await auth.authenticate(
        //  androidAuthStrings: AndroidAuthMessages(
        localizedReason: '얼굴을 인식하거나 지문을 스캔 해주세요.',
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
          biometricOnly: true,
        ),

        //  authMessages: const <AuthMessages>[
        //   AndroidAuthMessages(
        //     signInTitle: 'Oops! Biometric authentication required!',
        //     cancelButton: 'No thanks',
        //   ),
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
      // ignore: use_build_context_synchronously
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SimplePasswordPage(
              updatePasswordMatchStatus: updatePasswordMatchStatus);
        },
      );
      print("안녕 ???" + isPasswordMatched.toString());

      if (isPasswordMatched) {
        return true;
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 3);
        return false;
      }
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
    print("check 함수 시작");
    bool isLocalAuth;
    isLocalAuth = await LocalAuthentication().canCheckBiometrics;
    print(isLocalAuth);

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

    biometricsFlag.then((bool isAuthenticated) {
      if (isAuthenticated) {
        // Future<bool> NFCFlag = checkNFCAvailability();
        checkNFCAvailability();
        print("142줄 NFCFlag Error");

        print(NFCFlag);
        if (NFCFlag) {
          Future.delayed(Duration(seconds: 60), () async {
            if (!_isPaymentDone) {
              await NfcManager.instance.stopSession();
              showSuccessDialog(context, "시간 초과", "결제 시간이 초과했습니다. 다시 시도해주세요.",
                  () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/main", (route) => false,
                    arguments: 3);
              });

              print(
                  "60초가 지났다. 종료해라@@@@@@@@@60초가 지났다. 종료해라@@@@@@@@@60초가 지났다. 종료해라@@@@@@@@@60초가 지났다. 종료해라@@@@@@@@@");
            }
            return;
          });
        }
        if (!NFCFlag) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 3);
        }
        print("들어왔습니다.");
        _tagRead();
        // _ndefWrite();
      }
    });
  }

  void createPayment() async {
    print("생성@@@@@@@@@@@@@@@@생성");

    Map<String, dynamic> paymentCreatRequest = {
      "cardNum": args?["cardNum"],
      "cardType": "01",
      "amount": amount.toString(),
      "type": "01",
      "installPeriod": "0",
      "shopName": "SSOK-친환경 편의점",
      "shopNumber": "123-45-67890",
      "paymentItemList": paymentItemList
    };
    print(paymentCreatRequest);

    final response = await apiService.postRequestToVirtual(
        "pos/payment-service/payment",
        paymentCreatRequest,
        TokenManager().accessToken);
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showSuccessDialog(context, "결제 완료", "결제에 성공했습니다.", () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 3);
      });

      // Navigator.of(context).pop();
    } else {
      print(response.statusCode);
      // ignore: use_build_context_synchronously
      showSuccessDialog(context, "결제 실패", "결제에 실패했습니다. 다시 시도해주세요.", () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 3);
      });
      // Navigator.of(context).pop();
      throw Exception('Failed to load');
    }
  }

  void _tagRead() {
    // checkNFCAvailability();
    print("1231232131");

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      print("세션이 시작되었습니다.");
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
    String key = "";

    // 분할된 데이터를 변수에 할당
    for (String part in parts) {
      List<String> keyValue = part.split(':');
      String currentKey = keyValue[0];
      String value = keyValue[1];

      if (currentKey == 'amount') {
        amount = value;
      } else if (currentKey == 'itemSeq') {
        List<String> itemSeqList = value.split(',');
        List<String> itemCntList = parts
            .firstWhere((p) => p.startsWith('itemCnt:'))
            .split(':')[1]
            .split(',');

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
    createPayment();
  }

  Future<bool> checkNFCAvailability() async {
    print("@@?@??");
    if (!(await NfcManager.instance.isAvailable())) {
      print("gege");
      setState(() {
        NFCFlag = false;
      });
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.padding),
          ),
          elevation: 0,
          title: Text("오류", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Container(height: 50,child:WrappedKoreanText("NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.")),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await AppSettings.openAppSettings(type: AppSettingsType.nfc);
                setState(() {
                  NFCFlag = false;
                });
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/main", (route) => false,
                    arguments: 3);
              },
              child: Text("설정 "),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  NFCFlag = false;
                });
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/main", (route) => false,
                    arguments: 3);
              },
              child: Text("확인"),
            ),
          ],
        ),
      );
      // print("NFC 불가능!@@@@@@@@@@@@@@@@@@@@@@@@@@");
      return false;
      // throw "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.";
    } else {
      setState(() {
        _isNFC = true;
        NFCFlag = true;
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
        NdefRecord.createText(
            'amount:14280 / itemSeq:1,3 / itemCnt:1,2 / key:ssok'),
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

    // args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Future.delayed(Duration.zero, () {
      // ModalRoute.of(context)!.settings.arguments를 통해 데이터를 읽어옵니다.
      args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      // 읽어온 데이터를 출력하거나 다른 초기화 작업을 수행할 수 있습니다.
      if (args != null) {
        print("cardcardcardcardcardcardcardcardcard");
        print(args!['cardNum']); // 'value'
        print("3이 나왔니 ?..");
      }
    });

    check();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.15),
          Container(
              child: MyCreditCard(
            vertical: true,
            ownerName: args["ownerName"],
            cardNum: args["cardNum"],
          )),
          SizedBox(height: screenHeight * 0.1),
          // Container(
          //   alignment: Alignment.center,
          //   child: CreditCardPaymentTimer(),
          // ),
          // if(authenticated && _isNFC) CreditCardPaymentTimer() ,
          // CreditCardPaymentTimer(),
          authenticated && _isNFC ? CreditCardPaymentTimer() : Container(),
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
            authenticated && !_isNFC
                ? "NFC 기능을 켜주세요."
                : authenticated && _isNFC && !_isPaymentDone
                    ? "디바이스의 뒷면을 리더기에 대세요"
                    : "결제 중",
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
