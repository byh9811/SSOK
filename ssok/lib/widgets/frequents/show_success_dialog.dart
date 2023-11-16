import 'package:flutter/material.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

void showSuccessDialog(
    BuildContext context, String title, String content, Function() onPressed,
    {int? height}) {
  int tempHeight = height ?? 60;
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
        content: Container(
            height: tempHeight.toDouble(), child: WrappedKoreanText(content)),
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
