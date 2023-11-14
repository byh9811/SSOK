import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class AccountData {
  final String name;
  final String balance;
  final String bank;
  final String accNum;

  AccountData(
      {required this.name,
      required this.balance,
      required this.bank,
      required this.accNum});

  factory AccountData.fromJson(Map<String, dynamic> json) {
    print(json);
    return AccountData(
        name: json['name'].toString(),
        balance: json['balance'].toString(),
        bank: json['bank'].toString(),
        accNum: json['accNum'].toString());
  }
}

class _MyAccountState extends State<MyAccount> {
  ApiService apiService = ApiService();
  late AccountData accountData;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accountData = AccountData(name: '', balance: '', bank: '', accNum: '');
    getAccountInfo();
  }

  void getAccountInfo() async {
    final response = await apiService.getRequest(
        'receipt-service/account', TokenManager().accessToken);
    print("계좌 정보조회");
    print(jsonDecode(utf8.decode(response.bodyBytes)));
    if (response.statusCode == 200) {
      setState(() {
        accountData = AccountData.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes))['response']);
        isLoading = false;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var numberFormat = NumberFormat('###,###,###,###');
    return Padding(
      padding:
          EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.12,
        decoration: BoxDecoration(
          color: Color(0xFF8B8B8B),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.grey,
                  size: 50,
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.11,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.01),
                          child: Row(
                            children: [
                              Image.asset('assets/account_icon.png', width: 35),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.01),
                                child: Text(
                                  "${accountData.name}님의 통장",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              left: screenWidth * 0.04),
                          child: Text(
                            "${accountData.accNum} (${accountData.bank})",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.02),
                            child: Text(
                              "${numberFormat.format(double.parse(accountData.balance))}원",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                ],
              ),
      ),
    );
  }
}
