import 'dart:convert';

import 'package:flutter/material.dart';
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

  AccountData({
    required this.name,
    required this.balance,
    required this.bank,
    required this.accNum
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    print(json);
    return AccountData(
      name: json['name'].toString(),
      balance: json['balance'].toString(),
      bank: json['bank'].toString(),
      accNum: json['accNum'].toString()
    );
  }
}

class _MyAccountState extends State<MyAccount> {
  ApiService apiService = ApiService();
  late AccountData accountData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccountInfo();
  }

  void getAccountInfo() async{
    final response = await apiService.getRequest('receipt-service/account',TokenManager().accessToken);
    print("계좌 정보조회");
    print(jsonDecode(utf8.decode(response.bodyBytes)));
    if (response.statusCode == 200) {
      setState(() {
        accountData = AccountData.fromJson(jsonDecode(utf8.decode(response.bodyBytes))['response']);
      }); 
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.115,
        decoration: BoxDecoration(
          color: Color(0xFF8B8B8B),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/pigcoin.png",
                    height: 35,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          accountData.name+"님의 통장",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          accountData.balance,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          accountData.bank +": "+accountData.accNum,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    height: screenHeight * 0.09,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0, right: 14.0),
                      child: IconButton(
                        icon: Icon(Icons.more_horiz),
                        color: Colors.white,
                        splashColor: Colors.white,
                        onPressed: () {},
                        iconSize: 28.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
