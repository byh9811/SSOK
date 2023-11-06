import 'package:flutter/material.dart';
import 'package:ssok/screens/businesscard/card_self_create_page.dart';
import 'package:ssok/screens/id/drive_id_create_page.dart';
import 'package:ssok/screens/id/id_create_page.dart';

import 'package:ssok/screens/login/login_page.dart';
import 'package:ssok/screens/login/signin_page.dart';
import 'package:ssok/screens/main_page.dart';
import 'package:ssok/screens/pocket/pocket_account_create_page.dart';
import 'package:ssok/screens/pocket/pocket_donation_page.dart';
import 'package:ssok/screens/pocket/pocket_donation_send_page.dart';
import 'package:ssok/screens/pocket/pocket_pocket_create_page.dart';
import 'package:ssok/screens/pocket/pocket_transfer_page.dart';

void main() {
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
        '/signin':(context)=>SigninPage(),
        '/main': (context) => MainPage(),
        '/card/self/create': (context) => CardSelfCreatePage(),
        '/id/create': (context) => IdCreatePage(),
        '/drive/id/create': (context) => DriveIdCreatePage(),
        '/pocket/account/create': (context) => PocketAccountCreatePage(),
        '/pocket/pocket/create': (context) => PocketPocketCreatePage(),
        '/pocket/donation': (context) => PocketDonationPage(),
        '/pocket/donation/send': (context) => PocketDonationSendPage(),
        '/pocket/transfer': (context) => PocketTransferPage(),
      },
    );
  }
}
