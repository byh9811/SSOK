import 'dart:convert';

import 'package:flutter/material.dart';

import '../../http/http.dart';
import '../../http/token_manager.dart';

class IdCreatePage extends StatefulWidget {
  const IdCreatePage({super.key});

  @override
  State<IdCreatePage> createState() => _IdCreatePageState();
}

class _IdCreatePageState extends State<IdCreatePage> {

  ApiService apiService = ApiService();
  late String registrationCardName="";
  late String registrationCardPersonalNumber="";
  late String registrationCardAddress="";
  late String registrationCardIssueDate="";
  late String registrationCardAuthority="";

  bool checkRegistrationCardName = false;
  bool checkRegistrationCardPersonalNumber = false;
  bool checkRegistrationCardAddress = false;
  bool checkRegistrationCardIssueDate = false;
  bool checkRegistrationCardAuthority = false;

  void register() async {
    if(checkRegistrationCardName &&
        checkRegistrationCardPersonalNumber &&
        checkRegistrationCardAddress &&
        checkRegistrationCardIssueDate &&
        checkRegistrationCardAuthority){
      final response = await apiService.postRequest(
          'idcard-service/registration', {
            "registrationCardName": registrationCardName,
            "registrationCardPersonalNumber": registrationCardPersonalNumber,
            "registrationCardAddress": registrationCardAddress,
            "registrationCardIssueDate": registrationCardIssueDate,
            "registrationCardAuthority":registrationCardAuthority
      }, TokenManager().accessToken);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        throw Exception('Failed to load');
      }
    }
  }

  void ocr() async {
    final response = await apiService.postRequest(
        'idcard-service/scan/registration', {
    }, TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "주민등록증 정보 입력",
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Color(0xFF676767),
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // 원하는 색상으로 변경
        ),
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
                              registrationCardName = value;
                            },
                          ),
                          Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(labelText: '주민등록번호'),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value){
                                      registrationCardPersonalNumber=value.trim();
                                      checkRegistrationCardName = registrationCardName.isNotEmpty;
                                    },
                                  ),
                                )
                              ]
                          ),

                          Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(labelText: '주소'),
                                    keyboardType: TextInputType.streetAddress,
                                    onChanged: (value){
                                      setState(() {
                                        registrationCardAddress=value;
                                      });
                                    },
                                  ),
                                )
                              ]
                          ),
                          Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration:InputDecoration(labelText: '발급일자'),
                                    keyboardType: TextInputType.datetime,
                                    onChanged: (value){
                                      registrationCardIssueDate=value;
                                    },
                                  ),
                                ),
                              ]
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: '인증기관'),
                            keyboardType: TextInputType.text,
                            onChanged: (value){
                              setState(() {
                                registrationCardAuthority=value;
                              });
                            },
                          ),
                          Row(
                              children: [
                                Expanded(
                                  child: ButtonTheme(
                                      height: 50.0,
                                      child: ElevatedButton(
                                        onPressed: (){
                                          register();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent
                                        ),
                                        child: Icon(
                                          Icons.accessibility,
                                          color: Colors.white,
                                          size: 35.0,
                                        ),
                                      )
                                  ),
                                ),
                                ButtonTheme(
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        ocr();
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
                              ]
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
}
