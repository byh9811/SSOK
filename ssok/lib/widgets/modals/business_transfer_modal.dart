import 'package:flutter/material.dart';
import 'package:ssok/widgets/businesscards/childrens/modal_type_button.dart';

class BusinessTransferModal extends StatelessWidget {
  const BusinessTransferModal({super.key});

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
                title: "NFC",
                icon: Icons.nfc,
                ontap: () {},
              ),
              ModalTypeButton(
                title: "Bluetooth",
                icon: Icons.bluetooth_searching,
                ontap: () {},
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