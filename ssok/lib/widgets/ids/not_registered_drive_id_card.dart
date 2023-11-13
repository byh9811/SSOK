import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';

import '../../dto/recognized_license.dart';

class ImageAndLicenseData {
  final XFile image;
  final RecognizedLicense data;

  ImageAndLicenseData({required this.image, required this.data});
}

class NotRegisteredDriveIdCard extends StatefulWidget {
  const NotRegisteredDriveIdCard({super.key});

  @override
  State<NotRegisteredDriveIdCard> createState() =>
      _NotRegisteredDriveIdCardState();
}

class _NotRegisteredDriveIdCardState extends State<NotRegisteredDriveIdCard> {
  late XFile? pickedImage;
  final picker = ImagePicker();
  ApiService apiService = ApiService();
  String? accessToken;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    print(pickedFile);
    setState(() {
      pickedImage = pickedFile;
    });
  }

  Future<RecognizedLicense> ocrLicense() async {
    print("3:${pickedImage!.path}");
    File file = File(pickedImage!.path);
    Uint8List uint8list = await file.readAsBytes();
    final response = await apiService.postRequestWithFile(
        'idcard-service/scan/license',
        null,
        null,
        TokenManager().accessToken,
        uint8list);
    Map<String, dynamic> jsonData = jsonDecode(response);
    if (jsonData['success']) {
      Map<String, dynamic> data = jsonData['response'];

      return RecognizedLicense(
          licenseName: data["licenseName"],
          licensePersonalNumber: data["licensePersonalNumber"],
          licenseType: data["licenseType"],
          licenseAddress: data["licenseAddress"],
          licenseNumber: data["licenseNumber"],
          licenseRenewStartDate: data["licenseRenewStartDate"],
          licenseRenewEndDate: data["licenseRenewEndDate"],
          licenseCondition: data["licenseCondition"],
          licenseCode: data["licenseCode"],
          licenseIssueDate: data["licenseIssueDate"],
          licenseAuthority: data["licenseAuthority"]
      );
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom:screenHeight*0.01),
      child: contentBox(
        context,
        Column(
          children: [
            Expanded(
              child: Text(
                "등록된 운전면허증이 없습니다.",
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
                          await _pickImage();

                          print("2:$pickedImage");
                          final data = await ocrLicense();
                          Navigator.of(context).pushReplacementNamed(
                            '/drive/id/create',
                            arguments: ImageAndLicenseData(
                                image: pickedImage!, data: data),
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
      ),
    );
  }
}
