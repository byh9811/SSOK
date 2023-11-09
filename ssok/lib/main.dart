import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/businesscard/business_card_camera_create_page.dart';
import 'package:ssok/screens/businesscard/business_card_detail_page.dart';
import 'package:ssok/screens/businesscard/business_card_map_page.dart';
import 'package:ssok/screens/businesscard/business_card_my_page.dart';
import 'package:ssok/screens/businesscard/business_card_self_create_page.dart';
import 'package:ssok/screens/businesscard/business_card_transfer_bluetooth_page.dart';
import 'package:ssok/screens/creditcard/credit_card_create_page.dart';
import 'package:ssok/screens/creditcard/credit_card_history_list_page.dart';
import 'package:ssok/screens/creditcard/test.dart';
import 'package:ssok/screens/creditcard/test2.dart';
import 'package:ssok/screens/id/drive_id_create_page.dart';
import 'package:ssok/screens/id/id_create_page.dart';

import 'package:ssok/screens/login/login_page.dart';
import 'package:ssok/screens/login/signin_page.dart';
import 'package:ssok/screens/main_page.dart';
import 'package:ssok/screens/pocket/pocket_account_create_page.dart';
import 'package:ssok/screens/pocket/pocket_donation_page.dart';
import 'package:ssok/screens/pocket/pocket_donation_send_page.dart';
import 'package:ssok/screens/pocket/pocket_history_list.dart';
import 'package:ssok/screens/pocket/pocket_pocket_create_page.dart';
import 'package:ssok/screens/pocket/pocket_transfer_page.dart';
import 'package:ssok/screens/receipt/receipt_list_detail_page.dart';
import 'package:ssok/screens/creditcard/credit_card_payment_page.dart';

TokenManager tokenManager = TokenManager();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
      clientId: '6sfqyu6her',
      onAuthFailed: (error) {
        print('Auth failed: $error');
      });
  await tokenManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signin': (context) => SigninPage(),
        '/main': (context) => MainPage(),
        '/id/create': (context) => IdCreatePage(),
        '/drive/id/create': (context) => DriveIdCreatePage(),
        '/creditcard/payment': (context) => CreditCardPaymentPage(),
        '/businesscard/my': (context) => BusinessCardMyPage(),
        '/businesscard/detail': (context) => BusinessCardDetailPage(),
        '/businesscard/self/create': (context) => BusinessCardSelfCreatePage(),
        '/businesscard/camera/create': (context) =>
            BusinessCardCameraCreatePage(),
        '/businesscard/map': (context) => BusinessCardMapPage(),
        '/businesscard/transfer/bluetooth': (context) =>
            BusinessCardTransferBluetoothPage(),
        '/creditcard/create': (context) => CreditCardCreatePage(),
        '/creditcard/history/list': (context) => CreditCardHistoryListPage(),
        '/receipt/detail': (context) => ReceiptListDetailPage(),
        '/pocket/account/create': (context) => PocketAccountCreatePage(),
        '/pocket/pocket/create': (context) => PocketPocketCreatePage(),
        '/pocket/history/list': (context) => PocketHistoryList(),
        '/pocket/donation': (context) => PocketDonationPage(),
        '/pocket/donation/send': (context) => PocketDonationSendPage(),
        '/pocket/transfer': (context) => PocketTransferPage(),
        '/test': (context) => Test2(),
      },
    );
  }
}
