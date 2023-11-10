import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/creditcards/childrens/my_credit_card.dart';


class CreditCardHistory {
  final String date;
  final List<CreditCardDetail> creditCardDetail;
  final int totalHistory;
  final int totalPay;

  CreditCardHistory({
    required this.date,
    required this.creditCardDetail,
    required this.totalHistory,
    required this.totalPay,
  });
}

class CreditCardDetail {
  final int? receiptDetailDocumentId;
  final String shopName;
  final int payAmt;
  final String approvedDate;
  final String transactionType;

  CreditCardDetail({
    this.receiptDetailDocumentId,
    required this.shopName,
    required this.payAmt,
    required this.approvedDate,
    required this.transactionType,
  });
}

List<CreditCardHistory> parseCreditCardHistory(Map<String, Object?> jsonStr) {
  // final jsonData = json.decode(jsonStr);

  final response = jsonStr['response'] as Map<String, dynamic>?;
  print("1");
  print(response);

  List<CreditCardHistory> creditCardHistories = [];
  if (response != null) {
    response.forEach((key, value) {
      final creditCardDetail = (value['cardHistoryListResponses'] as List)
          .map((item) => CreditCardDetail(
                receiptDetailDocumentId: item['receiptDetailDocumentId'],
                shopName: item['shopName'],
                payAmt: item['payAmt'],
                approvedDate: item['approvedDate'],
                transactionType: item['transactionType'],
              ))
          .toList();
      final totalHistory = value["totalHistory"];
      final totalPay = value["totalPay"];

      creditCardHistories.add(CreditCardHistory(
        date: key,
        creditCardDetail: creditCardDetail,
        totalHistory: totalHistory,
        totalPay: totalPay,
      ));
    });
  }

  return creditCardHistories;
}

class CreditCardHistoryListPage extends StatefulWidget {
  const CreditCardHistoryListPage({super.key});

  @override
  State<CreditCardHistoryListPage> createState() => _CreditCardHistoryListPageState();
}

class _CreditCardHistoryListPageState extends State<CreditCardHistoryListPage> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  ApiService apiService = ApiService();
  late Map<String, Object?> jsonString={};
  late List<CreditCardHistory> creditCardHistories;

  @override
  void initState() {
    super.initState();
    getCardHistory();
    creditCardHistories = parseCreditCardHistory(jsonString);
    print(creditCardHistories);
  }

  void getCardHistory()async{
    final response = await apiService.getRequest('receipt-service/card/history/list', TokenManager().accessToken);
    print("카드 전체 내역 가져옴");
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    // print(jsonData['response']);
    if (response.statusCode == 200) {
      setState(() {
        jsonString = jsonData;
        creditCardHistories = parseCreditCardHistory(jsonString);
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    CreditCardHistory selectedCreditCardHistory = creditCardHistories.firstWhere((history) {
      final dateParts = history.date.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      return year == selectedYear && month == selectedMonth;
    }, orElse: () {
      return CreditCardHistory(
        date: '',
        totalHistory: 0,
        totalPay: 0,
        creditCardDetail: [],
      );
    });
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var numberFormat = NumberFormat('###,###,###,###');
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "카드 내역",
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
      body:Column(
        children: [
        SizedBox(height: screenHeight * 0.01),
        Container(
          alignment: Alignment.center,
          child: MyCreditCard(
            vertical: false,
            ownerName: args["ownerName"],
            cardNum: args["cardNum"]
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
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
                                  "${selectedCreditCardHistory.totalHistory}건",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFC72929),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
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
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.black, thickness: 1),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  height: screenHeight * 0.57,
                  child: ListView.builder(
                    itemCount:
                        selectedCreditCardHistory.creditCardDetail.length,
                    itemBuilder: (context, index) {
                      CreditCardDetail detailData =
                          selectedCreditCardHistory.creditCardDetail[index];
                      int? receiptDetailDocumentId = detailData.receiptDetailDocumentId;
                      String approvedDate = detailData.approvedDate;
                      int payAmt =detailData.payAmt;
                      String? shopName = detailData.shopName;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.04),
                        child: ListTile(
                          onTap: () {
                            receiptDetailDocumentId != null? 
                            Navigator.pushNamed(
                              context,
                              '/receipt/detail', //해당 영수증 페이지로 이동해야해
                              arguments: receiptDetailDocumentId,
                            ): (print("영수증 없는거임 뭐라도 해줘"));
                          },
                          title: Text(shopName),
                          subtitle: Text(
                            approvedDate.substring(0,10),
                            style: TextStyle(
                              color: Color(0xFFC9C9C9),
                            ),
                          ),
                          trailing: Text(
                            '${numberFormat.format(payAmt)}원',
                            style: TextStyle(
                              // color: receiptSeq == null
                              //     ? Color(0xFFC72929)
                              //     : Color(0xFF00168A),
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