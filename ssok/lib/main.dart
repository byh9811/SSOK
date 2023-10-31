import 'package:flutter/material.dart';
import 'package:ssok/screens/businesscard/self_create_card_page.dart';

import 'package:ssok/screens/login/login_page.dart';
import 'package:ssok/screens/main_page.dart';

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
        '/main': (context) => MainPage(),
        '/createCardSelf': (context) => SelfCreateCardPage(),
      },
    );
  }
}
