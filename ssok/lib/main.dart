import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/businesscard/business_card_camera_create_page.dart';
import 'package:ssok/screens/businesscard/business_card_detail_page.dart';
import 'package:ssok/screens/businesscard/business_card_history_page.dart';
import 'package:ssok/screens/businesscard/business_card_map_page.dart';
import 'package:ssok/screens/businesscard/business_card_my_history_page%20.dart';
import 'package:ssok/screens/businesscard/business_card_my_page.dart';
import 'package:ssok/screens/businesscard/business_card_self_create_page.dart';
import 'package:ssok/screens/businesscard/business_card_send_bluetooth_page.dart';
import 'package:ssok/screens/businesscard/business_card_receive_bluetooth_page.dart';
import 'package:ssok/screens/creditcard/credit_card_create_page.dart';
import 'package:ssok/screens/creditcard/credit_card_history_list_page.dart';
import 'package:ssok/screens/creditcard/test.dart';
import 'package:ssok/screens/creditcard/test2.dart';
import 'package:ssok/screens/id/drive_id_create_page.dart';
import 'package:ssok/screens/id/drive_id_detail_page.dart';
import 'package:ssok/screens/id/id_create_page.dart';
import 'package:ssok/screens/id/id_detail_page.dart';

import 'package:ssok/screens/login/login_page.dart';
import 'package:ssok/screens/login/signin_page.dart';
import 'package:ssok/screens/main_page.dart';
<<<<<<< HEAD
import 'package:ssok/screens/mainpage/business_card_page.dart';
=======
import 'package:ssok/screens/mainpage/credit_card_page.dart';
>>>>>>> 8107ce6df02ed2026fac477c403962c6b4871d15
import 'package:ssok/screens/pocket/pocket_account_create_page.dart';
import 'package:ssok/screens/pocket/pocket_donation_page.dart';
import 'package:ssok/screens/pocket/pocket_donation_send_page.dart';
import 'package:ssok/screens/pocket/pocket_history_list.dart';
import 'package:ssok/screens/pocket/pocket_pocket_create_page.dart';
import 'package:ssok/screens/pocket/pocket_transfer_page.dart';
import 'package:ssok/screens/receipt/receipt_list_detail_page.dart';
import 'package:ssok/screens/creditcard/credit_card_payment_page.dart';
import 'package:ssok/widgets/businesscards/registered_business_card.dart';

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
        // '/main' :(c ontext) => CreditCardPaymentPage(),
        '/id/create': (context) => IdCreatePage(),
        '/creditcard/main' : (context) => CreditCardPage(),
        '/id/detail': (context) => IdDetailPage(),
        '/drive/id/create': (context) => DriveIdCreatePage(),
        '/drive/id/detail': (context) => DriveIdDetailPage(),
        '/creditcard/payment': (context) => CreditCardPaymentPage(),
        '/businesscard/my': (context) => BusinessCardMyPage(),
        '/businesscard/page': (context) => BusinessCardPage(),
        '/businesscard/detail': (context) => BusinessCardDetailPage(),
        '/businesscard/self/create': (context) => BusinessCardSelfCreatePage(),
        '/businesscard/history': (context) => BusineessCardHistoryPage(),
        '/businesscard/myhistory': (context) => BusineessCardMyHistoryPage(),
        '/businesscard/camera/create': (context) =>
            BusinessCardCameraCreatePage(),
        '/businesscard/map': (context) => BusinessCardMapPage(),
        '/businesscard/send/bluetooth': (context) =>
            BusinessCardSendBluetoothPage(),
        '/businesscard/receive/bluetooth': (context) =>
            BusinessCardReceiveBluetoothPage(),
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
