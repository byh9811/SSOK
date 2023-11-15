import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

void confirmDialog(
    BuildContext context, String title, String content, Function() onPressed) {
  showDialog(
    context: context,
    barrierDismissible: false,
    // transitionDuration: Duration(milliseconds: 700),
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        // backgroundColor: Colors.transparent,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Container(height: 100, child: WrappedKoreanText(content)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            child: Text(
              "취소",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xFFF5F5F6)),
            ),
          ),
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

void showCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 240,
          child: SizedBox.expand(child: FlutterLogo()),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40)),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
