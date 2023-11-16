import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ssok/dto/recognized_reg_card.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/screens/loading/basic_loading_page.dart';
import 'package:ssok/screens/loading/transfer_loading_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';
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

  Future<void> pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio7x5
        ],
      );

      if (croppedFile != null) {
        setState(() {
          pickedImage = XFile(croppedFile.path);
        });
      }
    }
  }

  Future<RecognizedRegCard> ocrRC() async {
    File file = File(pickedImage!.path);
    Uint8List uint8list = await file.readAsBytes();
    final response = await apiService.postRequestWithFile(
        'idcard-service/scan/registration',
        null,
        null,
        TokenManager().accessToken,
        uint8list);
    Map<String, dynamic> jsonData = jsonDecode(response);
    print(jsonData);
    if (jsonData['success']) {
      Map<String, dynamic> data = jsonData['response'];
      return RecognizedRegCard(
          registrationCardName: data["registrationCardName"],
          registrationCardPersonalNumber:
              data["registrationCardPersonalNumber"],
          registrationCardAddress: data["registrationCardAddress"],
          registrationCardIssueDate: data["registrationCardIssueDate"],
          registrationCardAuthority: data["registrationCardAuthority"]);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("OCR 인식 실패"),
      // ));
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: contentBox(
        context,
        Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contact_mail,
                    size: 70,
                    color: Color.fromARGB(255, 206, 205, 205),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Text(
                      "등록된 주민등록증이 없습니다.",
                      style:
                          TextStyle(color: Color.fromARGB(255, 206, 205, 205)),
                    ),
                  ),
                ],
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
                          await pickAndCropImage();
                          if (pickedImage != null) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) {
                                  return TransferLoadingPage();
                                },
                              ),
                            );
                            try {
                              final data = await ocrRC();
                              print("data:$data");
                              Navigator.of(context).pushReplacementNamed(
                                '/id/create',
                                arguments: ImageAndRegData(
                                    image: pickedImage!, data: data),
                              );
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              showSuccessDialog(
                                  context, "OCR인식 실패", "주민등록증이 제대로 식별되지 않았습니다.",
                                  () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/main", (route) => false,
                                    arguments: 0);
                              });
                              // ScaffoldMessenger.of(context)
                              //     .showSnackBar(SnackBar(
                              //   content: Text("OCR 인식 실패"),
                              // ));
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //     "/main", (route) => false,
                              //     arguments: 0);
                            }
                          } else {
                            Navigator.of(context).pop();
                          }
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
