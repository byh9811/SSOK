import 'package:flutter/material.dart';
import 'package:ssok/widgets/receipts/childrens/dotted_divider.dart';

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
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.035),
            TitleByReceipt(
              title: "CU을지로파인애비뉴점",
              price: "2,000",
              cardInfo: "신한 신용카드 (0188)",
            ),
            SizedBox(height: screenHeight * 0.015),
            Divider(
              height: 1,
              thickness: 3,
              color: Colors.black,
            ),
            ContentByReceipt(
              title: "승인 일시",
              content: "2019-06-11 17:41:00",
            ),
            ContentByReceipt(
              title: "승인 번호",
              content: "30720911",
            ),
            ContentByReceipt(
              title: "거래 유형",
              content: "승인",
            ),
            ContentByReceipt(
              title: "할부",
              content: "일시불",
            ),
            SizedBox(height: screenHeight * 0.026),
            DottedDivider(),
            MenuByReceipt(
              title: "삼각김밥",
              amount: 1,
              price: "1,300",
            ),
            MenuByReceipt(
              title: "마이쮸",
              amount: 1,
              price: "700",
            ),
            SizedBox(height: screenHeight * 0.026),
            DottedDivider(),
            ContentByReceipt(
              title: "공급가액",
              content: "1,819원",
            ),
            ContentByReceipt(
              title: "부가세",
              content: "181원",
            ),
            SizedBox(height: screenHeight * 0.026),
            DottedDivider(),
            ContentByReceipt(
              title: "가맹점명",
              content: "CU을지로파인애비뉴점",
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
