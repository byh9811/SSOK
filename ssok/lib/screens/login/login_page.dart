import 'dart:io';
import 'package:ssok/http/token_manager.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ssok/screens/identification/service_aggreement_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TokenManager tokenManager;
  TextEditingController idController =
      TextEditingController(); // Controller for ID TextField
  TextEditingController passwordController =
      TextEditingController(); // Controller for Password TextField

  @override
  void initState() {
    super.initState();
    tokenManager = TokenManager();
  }

  void fetchTodos() async {
    String id = idController.text; // Get the entered ID
    String password = passwordController.text; // Get the entered password

    final response = await http.post(
        Uri.parse('https://gateway.ssok.site/api/member-service/member/login'),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonEncode({
          "loginId": id,
          "password": password
        })); // Use the entered ID and password

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      await tokenManager.setAccessToken(jsonData["response"]["accessToken"]);
      await tokenManager.setRefreshToken(jsonData["response"]["refreshToken"]);
      await tokenManager.setLoginId(jsonData["response"]["loginId"]);
      await tokenManager.setMemberName(jsonData["response"]["memberName"]);
      bool state = jsonData["response"]["serviceAgreement"];
      print("넣었다");
      print(jsonData["response"]["accessToken"]);
      print(jsonData["response"]["refreshToken"]);
      print(jsonData["response"]["loginId"]);
      print(jsonData["response"]["memberName"]);
      if (state) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        Navigator.of(context).pushReplacementNamed('/intro');
      }
    } else {
      _showAlertDialog();
      throw Exception('Failed to load album');
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('로그인 실패'),
          content: Text('아이디 혹은 비밀번호를 확인해주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 알림 창 닫기
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
                height: 300,
              ),
              SizedBox(height: screenHeight * 0.04),
              Form(
                  child: Column(
                children: [
                  TextField(
                    controller: idController, // Use the ID controller
                    decoration: InputDecoration(
                        labelText: 'ID',
                        hintText: "아이디를 입력하세요",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  TextField(
                    controller:
                        passwordController, // Use the password controller
                    obscureText: true, // 비밀번호 안보이도록 하는 것
                    decoration: InputDecoration(
                        labelText: 'PW',
                        hintText: " 비밀번호를 입력하세요",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
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
                  fetchTodos();
                },
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(200, 50))),
                child: Text("로그인"),
              ),
              SizedBox(height: screenHeight * 0.01),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ServiceAggreementPage(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/signin');
                          },
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(200, 50))),
                  child: Text("회원가입"))
            ],
          ),
        ),
      ),
    ));
  }
}
