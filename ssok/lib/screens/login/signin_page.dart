import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPage();
}

final formKey = GlobalKey<FormState>();
  
class _SigninPage extends State<SigninPage> {

  ApiService apiService = ApiService();
  late String name;
  late String phone;
  late String sms;
  late String id;
  late String password="";
  late String checkPassword="";
  late String simplePassword="";
  late String checkSimplePassword="";
  bool isCheckSms = false;
  bool isPasswordMismatch = false;
  bool isSimplePasswordMismatch = false;
  bool isPosId = false;

  void sendSms() async {
    final response = await apiService.postRequest('member-service/sms/send',{"to":phone}, TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }
  void checkSms() async {
    final response = await apiService.postRequest('member-service/sms/check',{"phone":phone, "sms":sms}, TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      setState(() {
        isCheckSms = jsonData['response'];
      });
    } else {
      throw Exception('Failed to load');
    }
  }
  void checkId() async {
    final response = await apiService.getRequest('member-service/member/check?id=${id}', TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      setState(() {
        isPosId = jsonData['response'];
      });
    } else {
      throw Exception('Failed to load');
    }
  }
  void signIn() async {
    if(isCheckSms && isPosId &&isPasswordMismatch &&isSimplePasswordMismatch){
      final response = await apiService.postRequest('member-service/member/create',{"loginId":id, "password":password, "name":name, "phone":phone, "simplePassword":simplePassword}, TokenManager().accessToken);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        throw Exception('Failed to load');
      }
    }
  }


@override
  Widget build(BuildContext context) {

    Color color = Theme.of(context).primaryColor;

    // Widget buttonSection = Container(
    //   child: Row( // 로우를 자식으로 가짐
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 자식들이 여유 공간을 공편하게 나눠가짐
    //     children: <Widget>[ // 세개의 위젯들을 자식들로 가짐
    //       _buildButtonColumn(color, Icons.call, 'CALL'),
    //       _buildButtonColumn(color, Icons.near_me, 'ROUTH'),
    //       _buildButtonColumn(color, Icons.share, 'SHARE')
    //     ],
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text('회원 가입'),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Center(
            child: Image(
              image: AssetImage('assets/horizonLogo.png'),
              width: 200.0,
            ),
          ),
          Form(
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.grey,
                  inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0))),
              child: Container(
                  padding: EdgeInsets.all(40.0),
                  // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                  // SingleChildScrollView으로 감싸 줌
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(labelText: '이름'),
                          keyboardType: TextInputType.name,
                          onChanged: (value){
                            name = value;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(labelText: '전화번호'),
                                keyboardType: TextInputType.phone,
                                onChanged: (value){
                                  phone=value;
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                sendSms();
                              },
                            child: Text("문자 인증")),
                          ]
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(labelText: '인증번호'),
                                keyboardType: TextInputType.phone,
                                onChanged: (value){
                                  setState(() {
                                    sms=value;
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                checkSms();
                              },
                            child: Text("인증 확인")),
                          ]
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                          decoration:InputDecoration(labelText: '아이디'),
                          keyboardType: TextInputType.text,
                          onChanged: (value){
                            id=value;
                          },
                        ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                checkId();
                              },
                            child: Text("중복 확인")),
                          ]
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: '비밀번호'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          onChanged: (value){
                            setState(() {
                              password=value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: '비밀번호 확인'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          onChanged: (value){
                            setState(() {
                              checkPassword=value;
                              isPasswordMismatch = password==checkPassword;
                            });
                          },
                          style: TextStyle(color: isPasswordMismatch ? Colors.black : Colors.red),
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: '2차 비밀번호'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          onChanged: (value){
                            setState(() {
                              simplePassword=value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '2차 비밀번호 확인',
                          ), // 비활성 상태 테두리 스타일),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          onChanged: (value){
                            setState((){
                              checkSimplePassword=value;
                              isSimplePasswordMismatch = simplePassword==checkSimplePassword;
                            });
                          },
                          style: TextStyle(color: isSimplePasswordMismatch ? Colors.black : Colors.red),
                        ),
                        ButtonTheme(
                          minWidth: 100.0,
                          height: 50.0,
                          child: ElevatedButton( 
                              onPressed: (){
                                signIn();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent
                              ),
                              child: Icon(
                                Icons.accessibility,
                                color: Colors.white,
                                size: 35.0,
                              ),
                          )
                        ),
                      ],
                    ),
                  )),
            )
          )
        ],
      ),
    );
  }
      Column _buildButtonColumn(Color color,IconData icon, String label){
        // 컬럼을 생성하여 반환
        return Column(
          mainAxisSize: MainAxisSize.min, // 여유공간을 최소로 할당
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          // 컬럼의 자식들로 아이콘과 컨테이너를 등록
          children: <Widget>[
            Icon(
              icon,
              color: color,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),  // 컨테이너 상단에 8픽셀의 마진을 할당
              child: Text(  // 텍스트 할당
                label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: color
                ),
              ),
            )
          ],
        );
      }
}