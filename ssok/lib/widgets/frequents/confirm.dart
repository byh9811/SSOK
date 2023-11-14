import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void confirmDialog(
    BuildContext context, String title, String content, Function() onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text("취소")
          ),
          TextButton(
            onPressed: onPressed,
            child: Text("확인"),
          ),
        ],
      );
    },
  );
}
