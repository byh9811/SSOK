import 'package:flutter/material.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({Key? key}) : super(key: key);

  @override
  State<ReceiptPage> createState() => _IdPageState();
}

class _IdPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("영수증페이지"),
    );
    ;
  }
}
