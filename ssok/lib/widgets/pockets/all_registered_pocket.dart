import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';
import 'package:ssok/widgets/pockets/childrens/my_account.dart';
import 'package:ssok/widgets/pockets/childrens/my_pocket.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class AllRegisteredPocket extends StatefulWidget {
  const AllRegisteredPocket({
    super.key,
    this.pocketTotalDonate,
    this.pocketTotalPoint,
    this.pocketIsChangeSaving,
  });
  final int? pocketTotalDonate;
  final int? pocketTotalPoint;
  final bool? pocketIsChangeSaving;

  @override
  State<AllRegisteredPocket> createState() => _AllRegisteredPocketState();
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class _AllRegisteredPocketState extends State<AllRegisteredPocket> {
  int level = 0;
  double exp = 0;
  // int name = 0;
  bool _isCheckedChanges = false;
  ApiService apiService = ApiService();

  Future<bool> editPocketIsChangeSaving() async {
    final response = await apiService.postRequestWithoutData(
        "pocket-service/pocket/change-saving", TokenManager().accessToken);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void showAlet() async {
    showSuccessDialog(context, "변경 실패", "잔돈 저금하기 변경에 실패했습니다. \n 다시 시도해주세요.",
        () {
      Navigator.of(context).pop();
    });
  }

  Future<bool> switchPocketIsChangeSaving() async {
    bool isSwitch = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        title: Text(
            _isCheckedChanges
                ? "잔돈 저금하기 취소" // 잔돈 저금하기 -> 저금 안하기
                : "잔돈 저금하기" // 잔돈 저금 안하기 -> 저금하기
            ,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Container(
          height: 100,
          child: WrappedKoreanText(
            _isCheckedChanges
                ? "더이상 결제 시 잔돈이 저금되지 않습니다."
                : "카드 결제 시 1000원 이하의 잔돈이 포켓머니에 저금 됩니다.\n\n예) 1,700 결제 시 300원 저금",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
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
            onPressed: () async {
              // Navigator.pop(context);
              // _isCheckedChanges = !_isCheckedChanges;
              isSwitch = true;

              if (await editPocketIsChangeSaving()) {
                Navigator.of(context).pop();
              } else {
                isSwitch = false;
                Navigator.of(context).pop();
                showAlet();
              }
            },
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
      ),
    );

    return isSwitch;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int pd = widget.pocketTotalDonate ?? 0;
    int pp = widget.pocketTotalPoint ?? 0;
    _isCheckedChanges = widget.pocketIsChangeSaving ?? false;
    int sum = pd + pp;

    if (0 <= sum && sum < 10000) {
      setState(() {
        level = 0;
        exp = (sum) / 10000.0;
        // name = "1";
      });
    } else if (10000 <= sum && sum < 50000) {
      print("?");
      setState(() {
        level = 1;
        exp = (sum - 10000) / 50000.0;
        // name = "2";
      });
    } else if (50000 <= sum && sum < 300000) {
      setState(() {
        level = 2;
        exp = (sum - 50000) / 300000.0;
        // name = "3";
      });
    } else if (300000 <= sum && sum < 1000000) {
      setState(() {
        level = 3;
        exp = (sum - 300000) / 1000000.0;
        // name = "4";
      });
    } else {
      setState(() {
        level = 4;
        exp = 1;
        // name = "5";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 108,
            ),
            Row(children: [
              Text(
                "잔돈 저금하기",
                style: TextStyle(fontSize: 15),
              ),
              Switch(
                value: _isCheckedChanges,
                onChanged: (value) async {
                  if (await switchPocketIsChangeSaving()) {
                    setState(() {
                      _isCheckedChanges = value;
                    });
                  }
                },
              )
            ]),
          ],
        ),
        MyAccount(),
        SizedBox(height: screenHeight * 0.02),
        MyPocket(
          onTap: () {
            Navigator.of(context).pushNamed('/pocket/history/list');
          },
        ),
        SizedBox(height: screenHeight * 0.03),
        Divider(
          height: 1,
          indent: screenWidth * 0.1,
          endIndent: screenWidth * 0.1,
          color: Color(0xFFB2B2B2),
        ),
        // SizedBox(height: screenHeight * 0.02),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                "assets/level_number${level}.png",
                height: 57,
              ),
              SizedBox(height: screenHeight * 0.015),
              // Text(name, style: TextStyle(fontSize: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/level${level}.png",
                    height: 180,
                  ),
                  Icon(Icons.info, color: Colors.grey),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("EXP ", style: TextStyle(fontSize: 18)),
                  SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: exp, // 진행 상태를 나타내는 값
                        minHeight: 20, // 프로그레스 바의 높이
                        backgroundColor: Colors.grey[300], // 배경 색상
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue), // 진행 바 색상
                      )),
                  // Icon(
                  //   Icons.help_center,
                  //   color: Colors.blue,
                  // ),
                  Text("  ${((exp * 100).toInt()).toString()}%",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ],
    );
  }
}
