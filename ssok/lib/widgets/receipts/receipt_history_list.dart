import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptHistoryList extends StatefulWidget {
  const ReceiptHistoryList({super.key});

  @override
  State<ReceiptHistoryList> createState() => _ReceiptHistoryListState();
}

class _ReceiptHistoryListState extends State<ReceiptHistoryList> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  List<Map<String, dynamic>> receiptList = [
    {
      'paymentAffiliatedStoreName': '가맹점 1',
      'paymentTransactionDateTime': '2023-11-02 10:30:00',
      'paymentAmount': 5000,
    },
    {
      'paymentAffiliatedStoreName': '가맹점 5',
      'paymentTransactionDateTime': '2023-11-02 10:30:00',
      'paymentAmount': 10000,
    },
    {
      'paymentAffiliatedStoreName': '가맹점 6',
      'paymentTransactionDateTime': '2023-11-02 10:30:00',
      'paymentAmount': 30000,
    },
    {
      'paymentAffiliatedStoreName': '가맹점 2',
      'paymentTransactionDateTime': '2023-10-02 15:45:00',
      'paymentAmount': 3550,
    },
    {
      'paymentAffiliatedStoreName': '가맹점 3',
      'paymentTransactionDateTime': '2023-09-02 18:20:00',
      'paymentAmount': 75200,
    },
    {
      'paymentAffiliatedStoreName': '가맹점 4',
      'paymentTransactionDateTime': '2022-12-02 10:30:00',
      'paymentAmount': 5000,
    },
  ];
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = receiptList.where((receipt) {
      final transactionDateTime =
          DateTime.parse(receipt['paymentTransactionDateTime']);
      return transactionDateTime.year == selectedYear &&
          transactionDateTime.month == selectedMonth;
    }).toList();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    Text(
                      "총",
                      style: TextStyle(fontSize: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.008, top: screenHeight * 0.003),
                      child: Text(
                        "5건",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFC72929)),
                      ),
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("사용합계 82,000원"))),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.02, left: screenWidth * 0.01),
                child: Row(
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
              ),
              SizedBox(height: screenHeight * 0.01),
              Divider(height: 1, color: Colors.black, thickness: 1),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                height: screenHeight * 0.539,
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = filteredList[index];

                    String affiliatedStoreName =
                        data['paymentAffiliatedStoreName'];
                    String transactionDateTime =
                        data['paymentTransactionDateTime'];
                    var numberFormat = NumberFormat('###,###,###,###');
                    String paymentAmount =
                        numberFormat.format(data['paymentAmount']);

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/receipt/detail',
                            arguments: data,
                          );
                        },
                        title: Text(affiliatedStoreName),
                        subtitle: Text(
                          '$transactionDateTime | 결제',
                          style: TextStyle(
                            color: Color(0xFFC9C9C9),
                          ),
                        ),
                        trailing: Text('$paymentAmount원'),
                        // 다른 위젯을 사용하여 원하는 형태로 출력을 수정할 수 있습니다.
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
