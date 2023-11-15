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
  late String name = "";
  late String phone;
  late String sms;
  late String id;
  late String password = "";
  late String checkPassword = "";
  late String simplePassword = "";
  late String checkSimplePassword = "";
  bool isCheckSms = false;
  bool isPasswordMismatch = false;
  bool isSimplePasswordMismatch = false;
  bool isPosId = false;

  Color sendColor = Colors.blue;
  Color smsColor = Colors.blue;
  Color idColor = Colors.blue;

  void sendSms() async {
    final response = await apiService.postRequest(
        'member-service/sms/send', {"to": phone}, TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _showAlertDialog("인증 문자를 전송했습니다.", "인증번호를 입력해주세요");
    } else {
      throw Exception('Failed to load');
    }
  }

  void checkSms() async {
    final response = await apiService.postRequest('member-service/sms/check',
        {"phone": phone, "sms": sms}, TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      setState(() {
        isCheckSms = jsonData['response'];
        if (isCheckSms) {
          smsColor = Colors.grey;
          _showAlertDialog("인증이 완료되었습니다.", "다음 절차를 진행해주세요.");
        } else {
          _showAlertDialog("인증에 실패했습니다.", "인증번호를 확인해주세요");
        }
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  void checkId() async {
    final response = await apiService.getRequest(
        'member-service/member/check?id=${id}', TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      setState(() {
        isPosId = jsonData['response'];
        if (isPosId) {
          _showAlertDialog("사용 가능한 아이디입니다", "다음 절차를 진행해주세요.");
        } else {
          _showAlertDialog("사용이 불가능한 아이디입니다..", "다른 아이디를 이용해주세요");
        }
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  void signIn() async {
    if (name != "" &&
        isCheckSms &&
        isPosId &&
        isPasswordMismatch &&
        isSimplePasswordMismatch) {
      final response = await apiService.postRequest(
          'member-service/member/create',
          {
            "loginId": id,
            "password": password,
            "name": name,
            "phone": phone,
            "simplePassword": simplePassword
          },
          TokenManager().accessToken);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        _showAlertDialog("회원가입이 완료되었습니다.", "환영합니다!");
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        throw Exception('Failed to load');
      }
    }
    if (name == "") {
      _showAlertDialog("회원 가입 실패", "이름을 입력해주세요.");
    } else if (!isCheckSms) {
      _showAlertDialog("회원 가입 실패", "문자 인증을 진행해주세요.");
    } else if (!isPosId) {
      _showAlertDialog("회원 가입 실패", "아이디 중복검사를 진행해주세요.");
    } else if (password == "") {
      _showAlertDialog("회원 가입 실패", "비밀번호를 입력해주세요.");
    } else if (!isPasswordMismatch) {
      _showAlertDialog("회원 가입 실패", "비밀번호가 일치하지 않습니다.");
    } else if (simplePassword == "") {
      _showAlertDialog("회원 가입 실패", "2차 비밀번호를 입력해주세요.");
    } else if (!isSimplePasswordMismatch) {
      _showAlertDialog("회원 가입 실패", "2차 비밀번호가 일치하지 않습니다.");
    }
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
    Color color = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('회원 가입'),
        elevation: 0.0,
        backgroundColor: Color(0xFF00ADEF),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                child: Theme(
              data: ThemeData(
                  primaryColor: Colors.grey,
                  inputDecorationTheme: InputDecorationTheme(
                      labelStyle:
                          TextStyle(color: Color(0xFF10298E), fontSize: 15.0))),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                  // SingleChildScrollView으로 감싸 줌
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: screenHeight * 0.01),
                        TextField(
                          decoration: InputDecoration(labelText: '이름'),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: isCheckSms,
                                decoration: InputDecoration(labelText: '전화번호'),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  phone = value;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: sendColor, // 원하는 색상으로 변경
                                  ),
                                  onPressed:
                                      !isCheckSms ? () => sendSms() : null,
                                  child: Text("문자 전송")),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: isCheckSms,
                                decoration: InputDecoration(labelText: '인증번호'),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  setState(() {
                                    sms = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: sendColor, // 원하는 색상으로 변경
                                  ),
                                  onPressed:
                                      !isCheckSms ? () => checkSms() : null,
                                  child: Text("인증 확인")),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: isPosId,
                                decoration: InputDecoration(labelText: '아이디'),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  id = value;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: idColor, // 원하는 색상으로 변경
                                  ),
                                  onPressed: !isPosId ? () => checkId() : null,
                                  child: Text("중복 확인")),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          decoration: InputDecoration(labelText: '비밀번호'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          onChanged: (value) {
                            setState(
                              () {
                                password = value;
                              },
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          decoration: InputDecoration(labelText: '비밀번호 확인'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          onChanged: (value) {
                            setState(() {
                              checkPassword = value;
                              isPasswordMismatch = password == checkPassword;
                            });
                          },
                          style: TextStyle(
                              color: isPasswordMismatch
                                  ? Colors.black
                                  : Colors.red),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          decoration: InputDecoration(labelText: '2차 비밀번호'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          onChanged: (value) {
                            setState(() {
                              simplePassword = value;
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '2차 비밀번호 확인',
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          onChanged: (value) {
                            setState(() {
                              checkSimplePassword = value;
                              isSimplePasswordMismatch =
                                  simplePassword == checkSimplePassword;
                            });
                          },
                          style: TextStyle(
                              color: isSimplePasswordMismatch
                                  ? Colors.black
                                  : Colors.red),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ButtonTheme(
                            minWidth: 100.0,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () {
                                signIn();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 239, 137, 4)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "회원가입",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )),
            ))
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
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
          margin: const EdgeInsets.only(top: 8), // 컨테이너 상단에 8픽셀의 마진을 할당
          child: Text(
            // 텍스트 할당
            label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: color),
          ),
        )
      ],
    );
  }
}
