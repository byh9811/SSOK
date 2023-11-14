import 'package:flutter/material.dart';

void showSuccessDialog(
    BuildContext context, String title, String content, Function() onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text("확인"),
          ),
        ],
      );
    },
  );
}
