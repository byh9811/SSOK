import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ssok/dto/recognized_reg_card.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';
import 'package:image_picker/image_picker.dart';

class ImageAndRegData {
  final XFile image;
  final RecognizedRegCard data;

  ImageAndRegData({required this.image, required this.data});
}

class NotRegisteredIdCard extends StatefulWidget {
  const NotRegisteredIdCard({super.key});

  @override
  State<NotRegisteredIdCard> createState() => _NotRegisteredIdCardState();
}

class _NotRegisteredIdCardState extends State<NotRegisteredIdCard> {
  ApiService apiService = ApiService();
  final picker = ImagePicker();
  late Map<String, Object?> jsonString = {};
  late XFile? pickedImage;

  Future<RecognizedRegCard> ocrLicense() async {
    print("3:${pickedImage!.path}");
    File file = File(pickedImage!.path);
    Uint8List uint8list = await file.readAsBytes();
    final response = await apiService.postRequestWithFile(
        'idcard-service/scan/license',
        null,
        null,
        TokenManager().accessToken,
        uint8list);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonData['response'];

      print(jsonData);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    print(pickedFile);
    setState(() {
      pickedImage = pickedFile;
    });
  }

  Future<RecognizedRegCard> ocrRC() async {
    final response = await apiService.postRequest(
        'idcard-service/scan/registration',
        {"img": "$pickedImage"},
        TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonData['response'];

      print(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return contentBox(
      context,
      Column(
        children: [
          Expanded(
            child: Text(
              "등록된 주민등록증이 없습니다.",
              style: TextStyle(color: Color(0xFF989898)),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.06,
            width: screenWidth * 0.7,
            child: registerButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceAggreementPage(
                      onTap: () async {
                        _pickImage();
                        final data = await ocrRC();
                        Navigator.of(context).pushReplacementNamed(
                          '/id/create',
                          arguments:
                              ImageAndRegData(image: pickedImage!, data: data),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      0.23,
    );
  }
}
