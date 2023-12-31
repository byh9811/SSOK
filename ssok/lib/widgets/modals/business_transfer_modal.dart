import 'package:flutter/material.dart';
import 'package:ssok/dto/business_card_data.dart';
import 'package:ssok/widgets/businesscards/childrens/modal_type_button.dart';

class BusinessTransferModal extends StatelessWidget {
  const BusinessTransferModal({
    Key? key,
    required this.myNamecardItem,
  }) : super(key: key);
  final MyNameCard myNamecardItem;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.67,
      height: screenHeight * 0.28,
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
          SizedBox(height: screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.023),
                child: ModalTypeButton(
                  title: "받기",
                  icon: Icons.archive,
                  ontap: () {
                    print(myNamecardItem.namecardName);
                    Navigator.of(context).pushNamed(
                        '/businesscard/receive/bluetooth',
                        arguments: myNamecardItem);
                  },
                  color: Color(0xFFC9FFB6),
                  splashColor: Color(0xFFA7FC89),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.023),
                child: ModalTypeButton(
                  title: "보내기",
                  icon: Icons.send,
                  ontap: () {
                    Navigator.of(context).pushNamed(
                        '/businesscard/send/bluetooth',
                        arguments: myNamecardItem);
                  },
                  color: Color(0xFFEFF299),
                  splashColor: Color(0xFFF2F76C),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
