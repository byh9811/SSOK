import 'package:flutter/material.dart';

Widget registerButton({required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF00ADEF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0), // 좌측 위 모서리
          bottomRight: Radius.circular(10.0), // 우측 위 모서리
        ),
      ),
    ),
    child: Text("등록", style: TextStyle(fontSize: 18)),
  );
}
