import 'package:flutter/material.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

void showSuccessDialog(
    BuildContext context, String title, String content, Function() onPressed) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text(
              "확인",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xFF00ADEF)),
            ),
          ),
        ],
      );
    },
  );
}
