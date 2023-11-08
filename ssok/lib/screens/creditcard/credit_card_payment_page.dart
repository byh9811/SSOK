import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ssok/widgets/creditcards/childrens/my_credit_card.dart';
import 'package:local_auth/local_auth.dart';

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

  Future<void> _authenticateWithBiometrics() async {
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
    bool isAvailable = await NfcManager.instance.isAvailable();
    print("됩니까? ${isAvailable}");

    // Start Session
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        // Do something with an NfcTag instance.
      },
    );
  }

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    check();
    _authenticateWithBiometrics();
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
            authenticated ? "결제 중" : "",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          if (authenticated)
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white), // 프로그레스 바 색상
            ),
        ],
      ),
    );
  }
}
