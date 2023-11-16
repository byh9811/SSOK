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
  int attempts = 5;

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
          if (attempts >= 1) {
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
        }
      } else {
        throw Exception('Failed to load');
      }
    }
  }

  void deleteSecretNumberState() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        result = result.substring(0, currentIndex);
        secretNumberStates[currentIndex] = false;
      });
    }
  }

  void clearSecretNumberState() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex = 0;
        result = "";
        secretNumberStates = List.generate(6, (index) => false);
      });
    }
  }

  void updateSecretNumberState(String index) {
    setState(() {
      secretNumberStates[currentIndex++] = true;
      result += index;
    });
    if (currentIndex == 6) {
      checkSimplePassword(TokenManager().loginId, result);
      setState(() {
        attempts--;
      });
      if (attempts == 0) {
        showSuccessDialog(context, "인증 실패", "다시 시도해주세요.", () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 3);
        });
      }
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
            Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text(
                  "간편 비밀번호 입력",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text("$attempts번 남았습니다.")
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                secretNumberStates.length,
                (index) => SecretNumberView(state: secretNumberStates[index]),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                    child: Container(
                      height: screenHeight * 0.5,
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
                              PasswordNumberButton(
                                num: "지움",
                                onTap: () => deleteSecretNumberState(),
                                text: true,
                              ),
                              PasswordNumberButton(
                                num: "0",
                                onTap: () => updateSecretNumberState("0"),
                              ),
                              PasswordNumberButton(
                                  num: "초기화",
                                  onTap: () => clearSecretNumberState(),
                                  text: true),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
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
    this.text,
  }) : super(key: key);
  final String num;
  final Function() onTap;
  final bool? text;
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
            color: Color(0xFF00496F),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        alignment: Alignment.center,
        child: Text(
          widget.num,
          style: TextStyle(
              fontSize: widget.text != null ? 20 : 30, color: Colors.white),
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
