import 'package:flutter/material.dart';

class CreditCardHistoryListPage extends StatefulWidget {
  const CreditCardHistoryListPage({super.key});

  @override
  State<CreditCardHistoryListPage> createState() => _CreditCardHistoryListPageState();
}

class _CreditCardHistoryListPageState extends State<CreditCardHistoryListPage> {
  @override
  Widget build(BuildContext context) {
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
      body:Text("D"),);
  }
}