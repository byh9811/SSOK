import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

class MyPocket extends StatefulWidget {
  const MyPocket({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;
  @override
  State<MyPocket> createState() => _MyPocketState();
}

class _MyPocketState extends State<MyPocket> {

  ApiService apiService = ApiService();
  late int pocketSaving=0;
  late int pocketTotalDonate=0;
  late int pocketTotalPoint=0;
  late int pocketTotalChange=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPocketInfo();
  }
  void getPocketInfo()async{
    final response = await apiService.getRequest('pocket-service/pocket',TokenManager().accessToken);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        pocketSaving= jsonDecode(response.body)['response']['pocketSaving'];
        pocketTotalDonate= jsonDecode(response.body)['response']['pocketTotalDonate'];
        pocketTotalPoint= jsonDecode(response.body)['response']['pocketTotalPoint'];
        pocketTotalChange= jsonDecode(response.body)['response']['pocketTotalChange'];
      });
      // Navigator.of(context).pushReplacementNamed('/pocket/account/create');
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: screenWidth,
          height: screenHeight * 0.115,
          decoration: BoxDecoration(
            color: Color(0xFF00496F),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.018, left: 13.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.paid,
                      color: Colors.white,
                      size: 23,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0, left: 3.0),
                      child: Text(
                        "포켓머니",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.07, right: 5.0),
                child: Row(
                  children: [
                    Text(
                      "${pocketSaving}원",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/pocket/transfer');
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            child: Text("이체"),
                          ),
                          Container(
                            height: screenHeight * 0.022,
                            width: 1,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            color: Colors.white,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/pocket/donation',arguments: pocketSaving);
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            child: Text("기부"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
