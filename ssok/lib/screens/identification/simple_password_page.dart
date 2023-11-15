import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';

class SimplePasswordPage extends StatefulWidget {
  const SimplePasswordPage({Key? key, required this.updatePasswordMatchStatus})
      : super(key: key);
  final Function(bool) updatePasswordMatchStatus;
  @override
  State<SimplePasswordPage> createState() => _SimplePasswordPageState();
}

class _SimplePasswordPageState extends State<SimplePasswordPage> {
  ApiService apiService = ApiService();
  List<bool> secretNumberStates = [false, false, false, false, false, false];
  String result = "";
  int currentIndex = 0;

  void checkSimplePassword(String? loginId, String simplePassword) async {
    if (loginId != null) {
      final response = await apiService.postRequest(
          'member-service/member/simplepassword',
          {
            "loginId": loginId,
            "simplePassword": simplePassword,
          },
          TokenManager().accessToken);
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["response"]) {
          // 간편 비밀번호 일치 시
          widget.updatePasswordMatchStatus(true);
          Navigator.of(context).pop();
        } else {
          // 간편 비밀번호 불일치 시
          // ignore: use_build_context_synchronously
          showSuccessDialog(context, "비밀번호 불일치", "비밀번호를 확인 후 다시 입력하세요", () {
            setState(() {
              secretNumberStates = List.generate(6, (index) => false);
              result = "";
              currentIndex = 0;
            });
            Navigator.of(context).pop();
          });
        }
      } else {
        throw Exception('Failed to load');
      }
    }
  }

  void updateSecretNumberState(String index) {
    setState(() {
      secretNumberStates[currentIndex++] = true;
      result += index;
    });
    if (currentIndex == 6) {
      checkSimplePassword(TokenManager().loginId, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12),
        child: Column(
          children: [
            Text(
              "2차 비밀번호 입력",
              style: TextStyle(fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                secretNumberStates.length,
                (index) => SecretNumberView(state: secretNumberStates[index]),
              ),
            ),
            Container(
              height: screenHeight * 0.5,
              color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PasswordNumberButton(
                        num: "1",
                        onTap: () => updateSecretNumberState("1"),
                      ),
                      PasswordNumberButton(
                        num: "2",
                        onTap: () => updateSecretNumberState("2"),
                      ),
                      PasswordNumberButton(
                        num: "3",
                        onTap: () => updateSecretNumberState("3"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PasswordNumberButton(
                        num: "4",
                        onTap: () => updateSecretNumberState("4"),
                      ),
                      PasswordNumberButton(
                        num: "5",
                        onTap: () => updateSecretNumberState("5"),
                      ),
                      PasswordNumberButton(
                        num: "6",
                        onTap: () => updateSecretNumberState("6"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PasswordNumberButton(
                        num: "7",
                        onTap: () => updateSecretNumberState("7"),
                      ),
                      PasswordNumberButton(
                        num: "8",
                        onTap: () => updateSecretNumberState("8"),
                      ),
                      PasswordNumberButton(
                        num: "9",
                        onTap: () => updateSecretNumberState("9"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PasswordNumberButton(num: "지움", onTap: () {}),
                      PasswordNumberButton(
                        num: "0",
                        onTap: () => updateSecretNumberState("0"),
                      ),
                      PasswordNumberButton(num: "", onTap: () {}),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordNumberButton extends StatefulWidget {
  const PasswordNumberButton({
    Key? key,
    required this.num,
    required this.onTap,
  }) : super(key: key);
  final String num;
  final Function() onTap;
  @override
  State<PasswordNumberButton> createState() => _PasswordNumberButtonState();
}

class _PasswordNumberButtonState extends State<PasswordNumberButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: screenHeight * 0.1,
        width: screenWidth * 0.2,
        decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        alignment: Alignment.center,
        child: Text(
          widget.num,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

class SecretNumberView extends StatefulWidget {
  const SecretNumberView({
    Key? key,
    required this.state,
  }) : super(key: key);
  final bool state;
  @override
  State<SecretNumberView> createState() => _SecretNumberViewState();
}

class _SecretNumberViewState extends State<SecretNumberView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.06,
      width: screenWidth * 0.1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 4.0,
          ),
        ),
      ),
      child: Text(widget.state ? "*" : " ", style: TextStyle(fontSize: 45)),
    );
  }
}
