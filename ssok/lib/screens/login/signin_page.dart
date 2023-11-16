import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late String phone="";
  late String sms="";
  late String id="";
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
    if(phone.length!=11 || phone.substring(0,3)!="010"){
      print(phone);
      _showAlertDialog("인증 문자 전송 실패", "올바른 전화번호를 입력해주세요.");
    }
    else{
      final response = await apiService.postRequest(
          'member-service/sms/send', {"to": phone}, TokenManager().accessToken);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _showAlertDialog("인증 문자를 전송했습니다.", "인증번호를 입력해주세요");
      } else {
        throw Exception('Failed to load');
      }
    }
  }

  void checkSms() async {

    if(sms.length!=5){
      _showAlertDialog("잘못된 인증번호입니다.", "인증번호를 확인해주세요.");      
    }else{
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
  }

  bool checkEnglish(String input) {
    RegExp regExp = RegExp(r'[a-zA-Z]'); // 영어(알파벳)를 나타내는 정규 표현식
    return regExp.hasMatch(input);
  }

  bool checkChar(String input) {
    RegExp regExp = RegExp(r'[^\w\s]'); // 영문자, 숫자, 공백을 제외한 모든 문자를 특수문자로 취급
    return regExp.hasMatch(input);
  }

  bool containsNumber(String input) {
    return RegExp(r'\d').hasMatch(input);
  }

  void checkId() async {
    if(id==""){
      _showAlertDialog("잘못된 형식의 아이디입니다.", "아이디를 입력해주세요.");      
    }else if(!checkEnglish(id)){
      _showAlertDialog("잘못된 형식의 아이디입니다.", "영문을 포함해주세요.");
    }else if(id.length<6){
      _showAlertDialog("잘못된 형식의 아이디입니다.", "6자리 이상 입력해주세요.");
    }else{
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
  }

  Future<bool> signIn() async {

    if (name == "") {
      _showAlertDialog("회원 가입 실패", "이름을 입력해주세요.");
    } else if (!isCheckSms) {
      _showAlertDialog("회원 가입 실패", "문자 인증을 진행해주세요.");
    } else if (!isPosId) {
      _showAlertDialog("회원 가입 실패", "아이디 중복검사를 진행해주세요.");
    } else if (password == "") {
      _showAlertDialog("회원 가입 실패", "비밀번호를 입력해주세요.");
    } else if(password.length<8 || !checkChar(password) || !containsNumber(password)){
      _showAlertDialog("잘못된 비밀번호입니다.", "알파벳, 숫자, 특수문자를 포함하여 8자리 이상의 비밀번호를 사용해주세요.");      
    }else if (!isPasswordMismatch) {
      _showAlertDialog("회원 가입 실패", "비밀번호가 일치하지 않습니다.");
    } else if (simplePassword == "") {
      _showAlertDialog("회원 가입 실패", "2차 비밀번호를 입력해주세요.");
    } else if (simplePassword.length!=6) {
      _showAlertDialog("잘못된 간편 비밀번호입니다.", "간편 비밀번호 6자리를 입력해주세요.");
    }else if (!isSimplePasswordMismatch) {
      _showAlertDialog("회원 가입 실패", "2차 비밀번호가 일치하지 않습니다.");
    }
    else if (name != "" &&
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
        _endSignIn("회원가입이 완료되었습니다!", "환영합니다!");
        return true;
      } else {
        _showAlertDialog("회원가입에 실패했습니다.", "회원가입에 실패했습니다.");
      }
    }
    return false;
  }

  void _showAlertDialog(String title, String content) async{
    await showDialog(
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
  void _endSignIn(String title, String content) async{
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
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
                          maxLength: 10,
                          buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) => null,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[가-힣]')), // 공백을 거부하는 형식 지정기
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: isCheckSms,
                                decoration: InputDecoration(labelText: '전화번호'),
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  // 추가로 필요한 경우 다른 형식 지정기를 여기에 추가할 수 있습니다.
                                ],
                                maxLength: 11,
                                onChanged: (value) {
                                  String trimmedValue = value.replaceAll(' ', '');
                                  phone = trimmedValue;
                                },
                                buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) => null,
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
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  // 추가로 필요한 경우 다른 형식 지정기를 여기에 추가할 수 있습니다.
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    sms = value;
                                  });
                                },
                                buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) => null,
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
                                decoration: InputDecoration(labelText: '아이디'),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  id = value;
                                  isPosId=false;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백을 거부하는 형식 지정기
                                  FilteringTextInputFormatter.deny(RegExp(r'[!@#%^&*(),.?":{}|<>]')), //특수문자를 거부하는
                                  FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9]')), //영어,숫자 제외 거부
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: idColor, // 원하는 색상으로 변경
                                  ),
                                  onPressed: () => checkId(),
                                  child: Text("중복 확인")),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          decoration: InputDecoration(labelText: '비밀번호(영문, 숫자, 특수문자 포함 8자리 이상)'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          maxLength: 25,
                          onChanged: (value) {
                            setState(() {
                                password = value;
                                isPasswordMismatch = password == checkPassword;
                              },
                            );
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백을 거부하는 형식 지정기
                          ],
                          buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) => null,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          decoration: InputDecoration(labelText: '비밀번호 확인'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          maxLength: 25,
                          onChanged: (value) {
                            setState(() {
                              checkPassword = value;
                              isPasswordMismatch = password == checkPassword;
                            });
                          },
                          buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) => null,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백을 거부하는 형식 지정기
                          ],
                          style: TextStyle(
                              color: isPasswordMismatch
                                  ? Colors.black
                                  : Colors.red),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          decoration: InputDecoration(labelText: '2차 비밀번호(6자리)'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          maxLength: 6,
                          onChanged: (value) {
                            setState(() {
                              simplePassword = value;
                              isSimplePasswordMismatch =
                                  simplePassword == checkSimplePassword;
                            });
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백을 거부하는 형식 지정기
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) => null,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '2차 비밀번호 확인',
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          maxLength: 6,
                          onChanged: (value) {
                            setState(() {
                              checkSimplePassword = value;
                              isSimplePasswordMismatch =
                                  simplePassword == checkSimplePassword;
                            });
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백을 거부하는 형식 지정기
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) => null,
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
                              onPressed: (){
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
