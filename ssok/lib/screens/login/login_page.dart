import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.18),
          Image.asset(
            'assets/mainLogo.png',
            height: 300,
          ),
          SizedBox(height: screenHeight * 0.1),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/main');
              },
              child: Text("로그인"))
        ],
      ),
    );
  }
}
