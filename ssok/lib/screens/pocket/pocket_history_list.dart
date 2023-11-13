import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
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
  final String? receiptDocumentId;
  final String pocketHistoryTitle;
  final String createTime;

  PocketDetail({
    required this.pocketHistorySeq,
    required this.pocketHistoryType,
    required this.pocketHistoryTransAmt,
    required this.pocketHistoryResultAmt,
    required this.receiptDocumentId,
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
                receiptDocumentId: item['receiptDocumentId'],
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

  ApiService apiService = ApiService();
  late Map<String, Object?> jsonString={};
  late List<PocketHistory> pocketHistories;

  @override
  void initState() {
    super.initState();
    getPocketHistory();
    pocketHistories = parsePocketHistory(jsonString);
  }

void getPocketHistory()async{
    final response = await apiService.getRequest('pocket-service/pocket/detail?detailType=0', TokenManager().accessToken);
    print("포켓 전체 내역 가져옴");
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    // print(jsonData['response']);
    if (response.statusCode == 200) {
      setState(() {
        jsonString = jsonData;
        pocketHistories = parsePocketHistory(jsonString);
      });
      print(jsonString);
      print(pocketHistories[0]);
    } else {
      throw Exception('Failed to load');
    }
}

void getDepositHistory()async{
    final response = await apiService.getRequest('pocket-service/pocket/detail?detailType=1', TokenManager().accessToken);
    print("포켓 입금 내역 가져옴");
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    // print(jsonData['response']);
    if (response.statusCode == 200) {
      setState(() {
        jsonString = jsonData;
        pocketHistories = parsePocketHistory(jsonString);
      });
      print("zz");
      print(jsonString);
    } else {
      setState(() {
        pocketHistories=[];
      });
      throw Exception('Failed to load');
    }
}

void getWithdrawHistory()async{
    final response = await apiService.getRequest('pocket-service/pocket/detail?detailType=2', TokenManager().accessToken);
    print("포켓 출금 내역 가져옴");
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    // print(jsonData['response']);
    if (response.statusCode == 200) {
      setState(() {
        jsonString = jsonData;
        pocketHistories = parsePocketHistory(jsonString);
      });
      print("zz");
      print(jsonString);
    } else {
        setState(() {
          pocketHistories=[];
        });
      throw Exception('Failed to load');
    }
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
                            onPressed: () {
                              getPocketHistory();
                            },
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
                            onPressed: () {
                              getDepositHistory();
                            },
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
                            onPressed: () {
                              getWithdrawHistory();
                            },
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
                      String? receiptDocumentId = detailData.receiptDocumentId;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.04),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/receipt/detail',
                              arguments: receiptDocumentId,
                            );
                          },
                          title: Text(pocketHistoryTitle),
                          subtitle: Text(
                            '$createTime | ${receiptDocumentId == null ? "출금" : "입금"}',
                            style: TextStyle(
                              color: Color(0xFFC9C9C9),
                            ),
                          ),
                          trailing: Text(
                            '${numberFormat.format(pocketHistoryTransAmt)}원',
                            style: TextStyle(
                              color: receiptDocumentId == null
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
