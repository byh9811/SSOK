import 'package:flutter/material.dart';
import 'package:ssok/widgets/businesscards/childrens/modal_type_button.dart';

class BusinessTransferModal extends StatelessWidget {
  const BusinessTransferModal({
    Key? key,
    required this.namecardSeq,
  }) : super(key: key);
  final int namecardSeq;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth * 0.75,
      height: screenHeight * 0.3,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Color(0xFF676767),
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            "교환",
            style: TextStyle(
              color: Color(0xFF656363),
              fontSize: 24,
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ModalTypeButton(
                title: "받기",
                icon: Icons.archive,
                ontap: () {
                  Navigator.of(context).pushNamed(
                      '/businesscard/receive/bluetooth',
                      arguments: namecardSeq);
                },
              ),
              ModalTypeButton(
                title: "보내기",
                icon: Icons.send,
                ontap: () {
                  Navigator.of(context).pushNamed(
                      '/businesscard/send/bluetooth',
                      arguments: namecardSeq);
                },
              ),
              ModalTypeButton(
                title: "Link",
                icon: Icons.share,
                ontap: () {
                  Navigator.of(context)
                      .pushReplacementNamed('/card/self/create');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
