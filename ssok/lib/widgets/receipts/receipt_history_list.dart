import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ssok/http/token_manager.dart';

import '../../http/http.dart';

class ReceiptHistory {
  final String date;
  final int totalHistory;
  final int totalPay;
  final List<ReceiptDetail> receiptDetailResponses;

  ReceiptHistory({
    required this.date,
    required this.totalHistory,
    required this.totalPay,
    required this.receiptDetailResponses,
  });
}

class ReceiptDetail {
  final String receiptDetailDocumentId;
  final String shopName;
  final int payAmt;
  final String approvedDate;
  final String transactionType;

  ReceiptDetail({
    required this.receiptDetailDocumentId,
    required this.shopName,
    required this.payAmt,
    required this.approvedDate,
    required this.transactionType
  });
}

List<ReceiptHistory> parseReceiptHistory(Map<String, dynamic> jsonStr) {
  final response = jsonStr['response'] as Map<String, dynamic>?;

  List<ReceiptHistory> receiptHistories = [];
  if (response != null) {
    response.forEach((key, value) {
      final receiptDetailResponses = (value['receiptListQueryResponses'] as List)
          .map((item) => ReceiptDetail(
              receiptDetailDocumentId: item['receiptDetailDocumentId'],
              shopName: item['shopName'],
              payAmt: item['payAmt'],
              approvedDate: item['approvedDate'],
              transactionType: item['transactionType']
            ))
          .toList();
      final totalHistory = value["totalHistory"];
      final totalPay = value["totalPay"];

      receiptHistories.add(ReceiptHistory(
        date: key,
        totalHistory: totalHistory,
        totalPay: totalPay,
        receiptDetailResponses: receiptDetailResponses
      ));
    });
  }

  return receiptHistories;
}

class ReceiptHistoryList extends StatefulWidget {
  const ReceiptHistoryList({super.key});

  @override
  State<ReceiptHistoryList> createState() => _ReceiptHistoryListState();
}

class _ReceiptHistoryListState extends State<ReceiptHistoryList> {
  int selectedMonth = DateTime
      .now()
      .month;
  int selectedYear = DateTime
      .now()
      .year;

  ApiService apiService = ApiService();
  late Map<String, Object?> jsonString = {};
  late List<ReceiptHistory> receiptHistories;

  @override
  void initState() {
    super.initState();
    getReceiptHistory();
    receiptHistories = parseReceiptHistory(jsonString);
  }

  void getReceiptHistory() async {
    final response = await apiService.getRequest(
        'receipt-service/receipt/list', TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      setState(() {
        jsonString = jsonData;
        receiptHistories = parseReceiptHistory(jsonString);
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    ReceiptHistory selectedReceiptHistory = receiptHistories.firstWhere((
        history) {
      final dateParts = history.date.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      return year == selectedYear && month == selectedMonth;
    }, orElse: () {
      return ReceiptHistory(
        date: '',
        totalHistory: 0,
        totalPay: 0,
        receiptDetailResponses: [],
      );
    });

    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var numberFormat = NumberFormat('###,###,###,###');

    return Column(
      children: [
        SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.01),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07),
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
                                      "${selectedReceiptHistory.totalHistory}건",
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
                                padding: EdgeInsets.only(
                                    top: screenHeight * 0.02),
                                child: Column(
                                  children: [
                                    Text(
                                      "사용 합계 ${numberFormat.format(
                                          selectedReceiptHistory.totalPay)}원",
                                      style: TextStyle(
                                        fontSize: 15,
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
                                selectedYear != DateTime
                                    .now()
                                    .year
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
                                onPressed: selectedYear == DateTime
                                    .now()
                                    .year &&
                                    selectedMonth == DateTime
                                        .now()
                                        .month
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
                        ],
                      ),
                    ),
                    Divider(height: 1, color: Colors.black, thickness: 1),
                    SizedBox(height: screenHeight * 0.01),
                    SizedBox(
                      height: screenHeight * 0.57,
                      child: ListView.builder(
                        itemCount:
                        selectedReceiptHistory.receiptDetailResponses.length,
                        itemBuilder: (context, index) {
                          ReceiptDetail detailData =
                          selectedReceiptHistory.receiptDetailResponses[index];
                          String receiptDetailDocumentId = detailData
                              .receiptDetailDocumentId;
                          String shopName = detailData.shopName;
                          String approvedDate = detailData.approvedDate;
                          int payAmt = detailData.payAmt;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenHeight * 0.04),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/receipt/$receiptDetailDocumentId',
                                  arguments: detailData,
                                );
                              },
                              title: Text(shopName),
                              subtitle: Text(
                                '$approvedDate | 결제',
                                style: TextStyle(
                                  color: Color(0xFFC9C9C9),
                                ),
                              ),
                              trailing: Text(
                                '${numberFormat.format(payAmt)}원',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
        )
      ],
    );
  }
}