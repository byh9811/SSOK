import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ssok/widgets/businesscards/childrens/modal_type_button.dart';

class BusinessCreateModal extends StatelessWidget {
  const BusinessCreateModal({super.key});

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
            "내 명함 등록",
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
                title: "촬영",
                icon: Icons.photo_camera,
                ontap: () {
                  Navigator.of(context)
                      .pushReplacementNamed('/businesscard/camera/create');
                },
              ),
              ModalTypeButton(
                title: "파일 업로드",
                icon: Icons.cloud_upload,
                ontap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    print(file);
                  } else {
                    // User canceled the picker
                  }
                },
              ),
              ModalTypeButton(
                title: "직접 생성",
                icon: Icons.palette,
                ontap: () {
                  Navigator.of(context)
                      .pushReplacementNamed('/businesscard/self/create');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
