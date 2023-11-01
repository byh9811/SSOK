import 'package:flutter/material.dart';

class IdCreatePage extends StatefulWidget {
  const IdCreatePage({super.key});

  @override
  State<IdCreatePage> createState() => _IdCreatePageState();
}

class _IdCreatePageState extends State<IdCreatePage> {
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
    );
  }
}
