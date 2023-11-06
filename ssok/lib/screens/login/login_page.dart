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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            children: <Widget>[
              SizedBox(height: screenHeight * 0.1),
              Image.asset(
                'assets/mainLogo.png',
                height: 250,
              ),
              SizedBox(height: screenHeight * 0.06),
              Form(
                  child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'ID',
                        hintText: "아이디를 입력하세요",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'PW',
                        hintText: " 입력하세요",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ],
              )),
              SizedBox(height: screenHeight * 0.06),
              ElevatedButton(
                  onPressed: () {

                    Navigator.of(context).pushReplacementNamed('/main');
                  },
                  child: Text("로그인")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signin');
                  },
                  child: Text("회원가입"))
            ],
          ),
              ),
            ),
        ));
  }
}
