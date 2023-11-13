import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ssok/widgets/receipts/childrens/dotted_divider.dart';

import '../../http/http.dart';
import '../../http/token_manager.dart';

class ReceiptDetailInfo {
  final String cardCompany;
  final String cardNumberFirstSection;
  final String cardType;
  final String approvedNum;
  final String shopName;
  final int payAmt;
  final String approvedDate;
  final String transactionType;
  List<InnerPaymentItem> paymentItemList;
  final int vat;
  final int priceWithOutVat;

  ReceiptDetailInfo({
    required this.cardCompany,
    required this.cardNumberFirstSection,
    required this.cardType,
    required this.approvedNum,
    required this.shopName,
    required this.payAmt,
    required this.approvedDate,
    required this.transactionType,
    required this.paymentItemList,
    required this.vat,
    required this.priceWithOutVat
  });
}

class InnerPaymentItem {
  final String itemName;
  final int itemPrice;
  final int itemCnt;

  InnerPaymentItem({
    required this.itemName,
    required this.itemPrice,
    required this.itemCnt
  });
}

ReceiptDetailInfo? parseReceiptDetail(Map<String, dynamic> jsonStr) {
  final response = jsonStr['response'] as Map<String, dynamic>?;
  print(response);
  if (response != null) {
    List<InnerPaymentItem> paymentItemList = (response['paymentItemList'] as List)
        .map((item) => InnerPaymentItem(
        itemName: item['itemName'],
        itemPrice: item['itemPrice'],
        itemCnt: item['itemCnt']
    )).toList();

    int vat = (response["payAmt"] / 10).toInt();

    return
      ReceiptDetailInfo(
        cardCompany: response["cardCompany"],
        cardNumberFirstSection: response["cardNumberFirstSection"],
        cardType: response["cardType"],
        approvedNum: response["approvedNum"],
        shopName: response["shopName"],
        payAmt: response["payAmt"],
        approvedDate: response["approvedDate"],
        transactionType: response["transactionType"],
        paymentItemList: paymentItemList,
        vat: vat,
        priceWithOutVat: response["payAmt"] - vat
      );
  }

  return null;
}

class ReceiptListDetailPage extends StatelessWidget {
  const ReceiptListDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "전자영수증",
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
      body: ReceiptDetail(),
    );
  }
}

class ReceiptDetail extends StatefulWidget {
  const ReceiptDetail({super.key});

  @override
  State<ReceiptDetail> createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends State<ReceiptDetail> {

  ApiService apiService = ApiService();
  late Map<String, Object?> jsonString = {};
  late ReceiptDetailInfo? receiptDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("왔다!");
      getReceiptDetail();
      receiptDetail = parseReceiptDetail(jsonString)!;
    });

  }

  void getReceiptDetail() async {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    print("getReceiptDetail");
    print(args);
    final response = await apiService.getRequest(
        'receipt-service/receipt/$args', TokenManager().accessToken);
    print(response);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      setState(() {
        jsonString = jsonData;
        receiptDetail = parseReceiptDetail(jsonString)!;
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (receiptDetail == null) {
      return CircularProgressIndicator(); // 또는 다른 로딩 위젯
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var numberFormat = NumberFormat('###,###,###,###');

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.035),
            TitleByReceipt(
              title: receiptDetail!.shopName,
              price: numberFormat.format(receiptDetail!.payAmt),
              cardInfo: "${receiptDetail!.cardCompany} ${receiptDetail!.cardType} (${receiptDetail!.cardNumberFirstSection})",
            ),
            SizedBox(height: screenHeight * 0.015),
            Divider(
              height: 1,
              thickness: 3,
              color: Colors.black,
            ),
            ContentByReceipt(
              title: "승인 일시",
              content: receiptDetail!.approvedDate,
            ),
            ContentByReceipt(
              title: "승인 번호",
              content: receiptDetail!.approvedNum,
            ),
            ContentByReceipt(
              title: "거래 유형",
              content: receiptDetail!.transactionType,
            ),
            ContentByReceipt(
              title: "할부",
              content: "일시불",
            ),
            SizedBox(height: screenHeight * 0.026),
            DottedDivider(),
            Column(
              children: receiptDetail!.paymentItemList.map((item) {
                return MenuByReceipt(
                  title: item.itemName,
                  amount: item.itemCnt,
                  price: '${numberFormat.format(item.itemPrice)}원',
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.026),
            DottedDivider(),
            ContentByReceipt(
              title: "공급가액",
              content: '${numberFormat.format(receiptDetail!.priceWithOutVat)}원',
            ),
            ContentByReceipt(
              title: "부가세",
              content: '${numberFormat.format(receiptDetail!.vat)}원',
            ),
            SizedBox(height: screenHeight * 0.026),
            DottedDivider(),
            ContentByReceipt(
              title: "가맹점명",
              content: receiptDetail!.shopName,
            ),
          ],
        ),
      ),
    );
  }
}

class TitleByReceipt extends StatelessWidget {
  const TitleByReceipt({
    Key? key,
    required this.title,
    required this.price,
    required this.cardInfo,
  }) : super(key: key);

  final String title;
  final String price;
  final String cardInfo;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * 0.007),
        Row(
          children: [
            Text(
              price,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "원",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        SizedBox(height: screenHeight * 0.03),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            cardInfo,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF747474),
            ),
          ),
        ),
      ],
    );
  }
}

class ContentByReceipt extends StatelessWidget {
  const ContentByReceipt({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.022),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFC2C2C2),
            ),
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

class MenuByReceipt extends StatelessWidget {
  const MenuByReceipt({
    Key? key,
    required this.title,
    required this.amount,
    required this.price,
  }) : super(key: key);

  final String title;
  final int amount;
  final String price;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.022),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.25),
            child: Text(
              "$amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
