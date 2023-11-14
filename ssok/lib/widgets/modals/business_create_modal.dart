import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssok/screens/loading/transfer_loading_page.dart';
import 'package:ssok/widgets/businesscards/childrens/modal_type_button.dart';

import '../../dto/recognized_namecard.dart';
import '../../http/http.dart';
import '../../http/token_manager.dart';
import '../content_box.dart';

class ImageAndNamecardData {
  final XFile image;
  final RecognizedNamecard data;
  final String apiUrl;

  ImageAndNamecardData(
      {required this.image, required this.data, required this.apiUrl});
}

class BusinessCreateModal extends StatefulWidget {
  final String? apiUrl;

  const BusinessCreateModal({super.key, this.apiUrl});

  @override
  State<BusinessCreateModal> createState() => _BusinessCreateModalState();
}

class _BusinessCreateModalState extends State<BusinessCreateModal> {
  ApiService apiService = ApiService();
  final picker = ImagePicker();
  late Map<String, Object?> jsonString = {};
  late String apiUrl;
  // late XFile? pickedImage;

  Future<XFile?> pickAndCropImageByCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      );

      if (croppedFile != null) {
        return XFile(croppedFile.path);
      }
      return null;
    }
  }

  Future<XFile?> pickAndCropImageByStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      XFile pickedFile = XFile(file.path);
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      );
      if (croppedFile != null) {
        return XFile(croppedFile.path);
      }
      return null;
    }
  }

  Future<RecognizedNamecard> ocrNC(File file) async {
    Uint8List uint8list = await file.readAsBytes();
    final response = await apiService.postRequestWithFile(
        'idcard-service/scan/namecard',
        null,
        null,
        TokenManager().accessToken,
        uint8list);
    Map<String, dynamic> jsonData = jsonDecode(response);

    if (jsonData['success']) {
      Map<String, dynamic> data = jsonData['response'];
      return RecognizedNamecard(
          /**
         * "name": "한",
            "company": "(입북동 서수원레이크푸르지",
            "department": "경기도 린시 로 77번길 62 102동 404호",
            "address": "경기도 린시 로 77번길 62 102동 404호",
            "position": null,
            "mobile": null,
            "tel": "970307-1",
            "fax": null,
            "email": null,
            "homepage": null
         */
          namecardName: data["name"] ?? "",
          namecardJob: data["position"] ?? data["department"] ?? "",
          namecardCompany: data["company"] ?? "",
          namecardAddress: data["address"] ?? "",
          namecardPhone: data["mobile"] ?? "",
          namecardTel: data["tel"] ?? "",
          namecardFax: data["fax"] ?? "",
          namecardEmail: data["email"] ?? "",
          namecardWebsite: data["homepage"] ?? "");
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    super.initState();
    apiUrl = widget.apiUrl ?? "namecard-service/";
    print("url입니다.............");
    print(apiUrl);
  }

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
                ontap: () async {
                  XFile? cuttedImage = await pickAndCropImageByCamera();
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false, // 배경이 투명해야 함을 나타냅니다
                      pageBuilder: (BuildContext context, _, __) {
                        return TransferLoadingPage();
                      },
                    ),
                  );
                  File file = File(cuttedImage!.path);
                  try {
                    final data = await ocrNC(file);
                    print("data:$data");
                    Navigator.of(context).pushReplacementNamed(
                      '/businesscard/camera/create',
                      arguments: ImageAndNamecardData(
                          image: cuttedImage!, data: data, apiUrl: apiUrl),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("OCR 인식 실패"),
                    ));
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/main", (route) => false,
                        arguments: 1);
                  }
                },
              ),
              ModalTypeButton(
                title: "파일 업로드",
                icon: Icons.cloud_upload,
                ontap: () async {
                  XFile? cuttedImage = await pickAndCropImageByStorage();
                  File file = File(cuttedImage!.path);
                  try {
                    final data = await ocrNC(file);
                    print("data:$data");
                    Navigator.of(context).pushReplacementNamed(
                      '/businesscard/camera/create',
                      arguments: ImageAndNamecardData(
                          image: cuttedImage!, data: data, apiUrl: apiUrl),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("OCR 인식 실패"),
                    ));
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/main", (route) => false,
                        arguments: 1);
                  }
                },
              ),
              ModalTypeButton(
                title: "직접 생성",
                icon: Icons.palette,
                ontap: () {
                  Navigator.of(context).pushReplacementNamed(
                      '/businesscard/self/create',
                      arguments: apiUrl);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
