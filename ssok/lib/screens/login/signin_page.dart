import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPage();
}

final formKey = GlobalKey<FormState>();
  
class _SigninPage extends State<SigninPage> {
@override
  Widget build(BuildContext context) {

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row( // 로우를 자식으로 가짐
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 자식들이 여유 공간을 공편하게 나눠가짐
        children: <Widget>[ // 세개의 위젯들을 자식들로 가짐
          _buildButtonColumn(color, Icons.call, 'CALL'),
          _buildButtonColumn(color, Icons.near_me, 'ROUTH'),
          _buildButtonColumn(color, Icons.share, 'SHARE')
        ],
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: Text('회원 가입'),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 30)),
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
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(labelText: '전화번호'),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/signin');
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
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/signin');
                              },
                            child: Text("인증 확인")),
                          ]
                        ),
                        TextField(
                          decoration:
                              InputDecoration(labelText: '아이디'),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: '비밀번호'),
                          keyboardType: TextInputType.text,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: '2차 비밀번호'),
                          keyboardType: TextInputType.text,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: '2차 비밀번호 확인'),
                          keyboardType: TextInputType.text,
                        ),
                        ButtonTheme(
                          minWidth: 100.0,
                          height: 50.0,
                          child: ElevatedButton( 
                              onPressed: (){
                                
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 35.0,
                              ),
                          )
                        ),
                        buttonSection
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