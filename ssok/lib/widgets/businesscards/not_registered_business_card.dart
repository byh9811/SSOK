import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/modals/business_create_modal.dart';
import 'package:ssok/widgets/register_button.dart';

import '../../dto/recognized_namecard.dart';
import '../../dto/recognized_reg_card.dart';
import '../../http/http.dart';
import '../../http/token_manager.dart';

class NotRegisteredBusinessCard extends StatefulWidget {
  const NotRegisteredBusinessCard({Key? key}) : super(key: key);

  @override
  State<NotRegisteredBusinessCard> createState() =>
      _NotRegisteredBusinessCardState();
}

class _NotRegisteredBusinessCardState extends State<NotRegisteredBusinessCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.1),
        introText(),
        SizedBox(height: screenHeight * 0.08),
        contentBox(
          context,
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "등록된 명함이 없습니다",
                    style: TextStyle(color: Color(0xFFD6D6D6)),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.06,
                width: screenWidth * 0.7,
                child: registerButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: BusinessCreateModal(),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
          0.27,
        ),
      ],
    );
  }

  Widget introText() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.08),
          child: Row(
            children: [
              Text(
                "명함 교환",
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF00ADEF),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(
                  "을",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.1),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "손쉽게 할 수 있어요",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
