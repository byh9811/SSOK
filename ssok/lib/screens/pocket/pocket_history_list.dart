import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ssok/widgets/pockets/childrens/my_pocket.dart';
import 'dart:convert';

class PocketHistory {
  final String date;
  final List<PocketDetail> pocketDetailResponses;
  final int totalHistory;
  final int deposit;
  final int withdrawal;

  PocketHistory({
    required this.date,
    required this.pocketDetailResponses,
    required this.totalHistory,
    required this.deposit,
    required this.withdrawal,
  });
}

class PocketDetail {
  final int pocketHistorySeq;
  final String pocketHistoryType;
  final int pocketHistoryTransAmt;
  final int pocketHistoryResultAmt;
  final int? receiptSeq;
  final String pocketHistoryTitle;
  final String createTime;

  PocketDetail({
    required this.pocketHistorySeq,
    required this.pocketHistoryType,
    required this.pocketHistoryTransAmt,
    required this.pocketHistoryResultAmt,
    this.receiptSeq,
    required this.pocketHistoryTitle,
    required this.createTime,
  });
}

List<PocketHistory> parsePocketHistory(Map<String, Object?> jsonStr) {
  // final jsonData = json.decode(jsonStr);

  final response = jsonStr['response'] as Map<String, dynamic>?;
  final pocketDetailMap = response?['pocketDetailMap'] as Map<String, dynamic>?;

  List<PocketHistory> pocketHistories = [];
  if (pocketDetailMap != null) {
    pocketDetailMap.forEach((key, value) {
      final pocketDetailResponses = (value['pocketDetailResponses'] as List)
          .map((item) => PocketDetail(
                pocketHistorySeq: item['pocketHistorySeq'],
                pocketHistoryType: item['pocketHistoryType'],
                pocketHistoryTransAmt: item['pocketHistoryTransAmt'],
                pocketHistoryResultAmt: item['pocketHistoryResultAmt'],
                receiptSeq: item['receiptSeq'],
                pocketHistoryTitle: item['pocketHistoryTitle'],
                createTime: item['createTime'],
              ))
          .toList();
      final totalHistory = value["totalHistory"];
      final deposit = value["deposit"];
      final withdrawal = value["withdrawal"];

      pocketHistories.add(PocketHistory(
        date: key,
        pocketDetailResponses: pocketDetailResponses,
        totalHistory: totalHistory,
        deposit: deposit,
        withdrawal: withdrawal,
      ));
    });
  }

  return pocketHistories;
}

class PocketHistoryList extends StatefulWidget {
  const PocketHistoryList({super.key});

  @override
  State<PocketHistoryList> createState() => _PocketHistoryListState();
}

class _PocketHistoryListState extends State<PocketHistoryList> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final Map<String, Object?> jsonString = {
    "success": true,
    "response": {
      "pocketDetailMap": {
        "2023-11": {
          "pocketDetailResponses": [
            {
              "pocketHistorySeq": 1,
              "pocketHistoryType": "CARBON",
              "pocketHistoryTransAmt": 1500,
              "pocketHistoryResultAmt": 1500,
              "receiptSeq": 1,
              "pocketHistoryTitle": "탄소 중립포인트 적립",
              "createTime": "2023-11-06T20:14:43.785"
            },
            {
              "pocketHistorySeq": 2,
              "pocketHistoryType": "DONATION",
              "pocketHistoryTransAmt": 500,
              "pocketHistoryResultAmt": 1000,
              "receiptSeq": null,
              "pocketHistoryTitle": "기부",
              "createTime": "2023-11-06T20:14:53.972"
            },
            {
              "pocketHistorySeq": 3,
              "pocketHistoryType": "DONATION",
              "pocketHistoryTransAmt": 500,
              "pocketHistoryResultAmt": 500,
              "receiptSeq": null,
              "pocketHistoryTitle": "기부",
              "createTime": "2023-11-06T20:14:55.062"
            },
            {
              "pocketHistorySeq": 4,
              "pocketHistoryType": "DONATION",
              "pocketHistoryTransAmt": 500,
              "pocketHistoryResultAmt": 0,
              "receiptSeq": null,
              "pocketHistoryTitle": "기부",
              "createTime": "2023-11-06T20:14:56.085"
            },
            {
              "pocketHistorySeq": 5,
              "pocketHistoryType": "CARBON",
              "pocketHistoryTransAmt": 100,
              "pocketHistoryResultAmt": 100,
              "receiptSeq": 1,
              "pocketHistoryTitle": "탄소 중립포인트 적립",
              "createTime": "2023-11-06T20:15:50.727"
            },
            {
              "pocketHistorySeq": 6,
              "pocketHistoryType": "CARBON",
              "pocketHistoryTransAmt": 100,
              "pocketHistoryResultAmt": 200,
              "receiptSeq": 1,
              "pocketHistoryTitle": "탄소 중립포인트 적립",
              "createTime": "2023-11-06T20:16:23.472"
            },
            {
              "pocketHistorySeq": 7,
              "pocketHistoryType": "CARBON",
              "pocketHistoryTransAmt": 200,
              "pocketHistoryResultAmt": 400,
              "receiptSeq": 1,
              "pocketHistoryTitle": "탄소 중립포인트 적립",
              "createTime": "2023-11-06T20:16:58.877"
            },
            {
              "pocketHistorySeq": 8,
              "pocketHistoryType": "CARBON",
              "pocketHistoryTransAmt": 300,
              "pocketHistoryResultAmt": 700,
              "receiptSeq": 1,
              "pocketHistoryTitle": "탄소 중립포인트 적립",
              "createTime": "2023-11-04T20:17:01.952"
            },
            {
              "pocketHistorySeq": 9,
              "pocketHistoryType": "CARBON",
              "pocketHistoryTransAmt": 100,
              "pocketHistoryResultAmt": 800,
              "receiptSeq": 1,
              "pocketHistoryTitle": "탄소 중립포인트 적립",
              "createTime": "2023-11-06T20:17:04.673"
            }
          ],
          "totalHistory": 9,
          "deposit": 2300,
          "withdrawal": 1500
        },
        "2023-08": {
          "pocketDetailResponses": [
            {
              "pocketHistorySeq": 10,
              "pocketHistoryType": "CARBON",
              "pocketHistoryTransAmt": 100,
              "pocketHistoryResultAmt": 900,
              "receiptSeq": 1,
              "pocketHistoryTitle": "탄소 중립포인트 적립",
              "createTime": "2023-08-04T20:17:05.149"
            }
          ],
          "totalHistory": 1,
          "deposit": 100,
          "withdrawal": 0
        },
        "2023-10": {
          "pocketDetailResponses": [
            {
              "pocketHistorySeq": 11,
              "pocketHistoryType": "CARBON",
              "pocketHistoryTransAmt": 100,
              "pocketHistoryResultAmt": 1000,
              "receiptSeq": 1,
              "pocketHistoryTitle": "탄소 중립포인트 적립",
              "createTime": "2023-10-05T20:17:05.784"
            }
          ],
          "totalHistory": 1,
          "deposit": 100,
          "withdrawal": 0
        }
      },
      "pocketSaving": 0
    },
    "error": null
  }; // JSON 데이터 문자열
  late List<PocketHistory> pocketHistories;

  @override
  void initState() {
    super.initState();
    pocketHistories = parsePocketHistory(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    PocketHistory selectedPocketHistory = pocketHistories.firstWhere((history) {
      final dateParts = history.date.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      return year == selectedYear && month == selectedMonth;
    }, orElse: () {
      return PocketHistory(
        date: '',
        totalHistory: 0,
        deposit: 0,
        withdrawal: 0,
        pocketDetailResponses: [],
      );
    });

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var numberFormat = NumberFormat('###,###,###,###');

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            "포켓머니",
            style: TextStyle(
              fontSize: 19,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, // 원하는 색상으로 변경
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            MyPocket(),
            SizedBox(height: screenHeight * 0.01),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "총",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.008,
                                    top: screenHeight * 0.003),
                                child: Text(
                                  "${selectedPocketHistory.totalHistory}건",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFC72929),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.02),
                            child: Column(
                              children: [
                                Text(
                                  "적립 + ${numberFormat.format(selectedPocketHistory.deposit)}원",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF00168A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  "사용 - ${numberFormat.format(selectedPocketHistory.withdrawal)}원",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFC72929),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.01, left: screenWidth * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_left),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            iconSize: 35,
                            onPressed: () {
                              if (selectedMonth == 1) {
                                setState(() {
                                  selectedYear--;
                                  selectedMonth = 12;
                                });
                              } else {
                                setState(() {
                                  selectedMonth--;
                                });
                              }
                            },
                          ),
                          Text(
                            selectedYear != DateTime.now().year
                                ? "$selectedYear  $selectedMonth월"
                                : "$selectedMonth월",
                            style: TextStyle(fontSize: 17),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            iconSize: 35,
                            disabledColor: Color(0xFFC9C9C9),
                            onPressed: selectedYear == DateTime.now().year &&
                                    selectedMonth == DateTime.now().month
                                ? null
                                : () {
                                    if (selectedMonth == 12) {
                                      setState(() {
                                        selectedYear++;
                                        selectedMonth = 1;
                                      });
                                    } else {
                                      setState(() {
                                        selectedMonth++;
                                      });
                                    }
                                  },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              "전체",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              "입금",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                            ),
                            onPressed: () {},
                            child: Text(
                              "출금",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.black, thickness: 1),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  height: screenHeight * 0.57,
                  child: ListView.builder(
                    itemCount:
                        selectedPocketHistory.pocketDetailResponses.length,
                    itemBuilder: (context, index) {
                      PocketDetail detailData =
                          selectedPocketHistory.pocketDetailResponses[index];
                      int pocketHistorySeq = detailData.pocketHistorySeq;
                      String pocketHistoryTitle = detailData.pocketHistoryTitle;
                      String createTime = detailData.createTime;
                      int pocketHistoryTransAmt =
                          detailData.pocketHistoryTransAmt;
                      int? receiptSeq = detailData.receiptSeq;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.04),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/receipt/detail',
                              arguments: detailData,
                            );
                          },
                          title: Text(pocketHistoryTitle),
                          subtitle: Text(
                            '$createTime | ${receiptSeq == null ? "출금" : "입금"}',
                            style: TextStyle(
                              color: Color(0xFFC9C9C9),
                            ),
                          ),
                          trailing: Text(
                            '${numberFormat.format(pocketHistoryTransAmt)}원',
                            style: TextStyle(
                              color: receiptSeq == null
                                  ? Color(0xFFC72929)
                                  : Color(0xFF00168A),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
