import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/frequents/main_button.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';

class EnterAmount extends StatefulWidget {
  const EnterAmount(
      {Key? key, required this.buttonTitle, required this.donateSeq})
      : super(key: key);
  final String buttonTitle;
  final int donateSeq;

  @override
  State<EnterAmount> createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  ApiService apiService = ApiService();

  int withDrawMoney = 0;

  void sendMoneyToDonate() async {
    if (withDrawMoney <= 0) {
      showSuccessDialog(context, "기부 실패", "1원 이상의 금액만 기부할 수 있습니다.", () {
        Navigator.of(context).pop();
      });
      return;
    }

    final response = await apiService.postRequest(
        'pocket-service/donate',
        {
          "donateSeq": widget.donateSeq.toString(),
          "donateAmt": withDrawMoney.toString()
        },
        TokenManager().accessToken);
    print(response.body);
    if (response.statusCode == 200) {
      showSuccessDialog(context, "이체 성공", "기부가 완료되었습니다.", () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 2);
      });
      print(response.body);
      // Navigator.of(context).pushNamedAndRemoveUntil("/main", (route) => false);
    } else if (response.statusCode == 400) {
      // 금액이 부족할떄
      if (jsonDecode(response.body)['error']['status'] == 400) {
        // ignore: use_build_context_synchronously
        showSuccessDialog(context, "기부 실패", "보유 포켓머니가 부족합니다.", () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showSuccessDialog(context, "기부 실패", "잠시후 다시 시도 해주세요.", () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 2);
      });
    }
  }

  void sendMoneyToMyAccount() async {
    if (withDrawMoney <= 0) {
      showSuccessDialog(context, "이체 실패", "1원 이상의 금액만 이체할 수 있습니다.", () {
        Navigator.of(context).pop();
      });
      return;
    }

    final response = await apiService.postRequest(
        'pocket-service/pocket/history',
        {
          "pocketHistoryType": "WITHDRAWAL",
          "pocketHistoryTransAmt": withDrawMoney.toString()
        },
        TokenManager().accessToken);
    print(response.body);
    if (response.statusCode == 200) {
      showSuccessDialog(context, "이체 성공", "이체가 완료되었습니다.", () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 2);
      });

      print(response.body);
      // Navigator.of(context).pushNamedAndRemoveUntil("/main", (route) => false);
    } else if (response.statusCode == 400) {
      // 금액이 부족할떄
      if (jsonDecode(response.body)['error']['status'] == 400) {
        // ignore: use_build_context_synchronously
        // showAlet("이체", "보유 포켓머니가 부족합니다.", false);
        showSuccessDialog(context, "이체 실패", "보유 포켓머니가 부족합니다.", () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showSuccessDialog(context, "이체 실패", "잠시후 다시 시도 해주세요.", () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 2);
      });
    }
  }

  void showAlet(String msg, String bodyMsg, bool isSuccess,
      {String? msg2, String? msg3}) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          msg2 != null ? msg2 : msg,
        ),
        content: Text(
          msg3 != null ? msg3 : bodyMsg,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (isSuccess) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/main", (route) => false,
                    arguments: 2);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  void changeMoney(int money) {
    setState(() {
      withDrawMoney = money;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.1),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  onChanged: (text) {
                    changeMoney(int.parse(text));
                  }, // 텍스트 변경시 실행되는 함수
                  onSubmitted: (text) {}, // Enter를 누를 때 실행되는 함수
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding: EdgeInsets.only(top: screenHeight * 0.018),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.04, top: screenHeight * 0.02),
                child: Text(
                  "원",
                  style: TextStyle(fontSize: 22),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        MainButton(
            color: "0xFF00ADEF",
            title: widget.buttonTitle,
            onPressed: () {
              if (widget.donateSeq == 0) {
                sendMoneyToMyAccount();
              } else {
                sendMoneyToDonate();
              }
            })
      ],
    );
  }
}
