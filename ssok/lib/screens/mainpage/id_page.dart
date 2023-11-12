import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/identification/service_aggreement_page.dart';
import 'package:ssok/widgets/content_box.dart';
import 'package:ssok/widgets/register_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class IDPage extends StatefulWidget {
  const IDPage({Key? key}) : super(key: key);

  @override
  State<IDPage> createState() => _IdPageState();
}

class RegistrationCard {
  final String registrationCardName;
  final String registrationCardPersonalNumber;

  RegistrationCard(
      {required this.registrationCardName,
      required this.registrationCardPersonalNumber});
}

class License {
  final String licenseName;
  final String licensePersonalNumber;

  License({required this.licenseName, required this.licensePersonalNumber});
}

class RecognizedRegCard {
  final String registrationCardName;
  final String registrationCardPersonalNumber;
  final String registrationCardAddress;
  final String registrationCardIssueDate;
  final String registrationCardAuthority;

  RecognizedRegCard(
      {required this.registrationCardName,
      required this.registrationCardPersonalNumber,
      required this.registrationCardAddress,
      required this.registrationCardIssueDate,
      required this.registrationCardAuthority});
}

class RecognizedLicense {
  final String licenseName;
  final String licensePersonalNumber;
  final String licenseType;
  final String licenseAddress;
  final String licenseNumber;
  final String licenseRenewStartDate;
  final String licenseRenewEndDate;
  final String licenseCondition;
  final String licenseCode;
  final String licenseIssueDate;
  final String licenseAuthority;

  RecognizedLicense(
      {required this.licenseName,
      required this.licensePersonalNumber,
      required this.licenseType,
      required this.licenseAddress,
      required this.licenseNumber,
      required this.licenseRenewStartDate,
      required this.licenseRenewEndDate,
      required this.licenseCondition,
      required this.licenseCode,
      required this.licenseIssueDate,
      required this.licenseAuthority});
}

class ImageAndData {
  final XFile image;
  final RecognizedRegCard data;

  ImageAndData({required this.image, required this.data});
}

class _IdPageState extends State<IDPage> {
  ApiService apiService = ApiService();
  String? accessToken;
  bool isIdCardHave = false;
  bool isLicenseHave = false;
  final picker = ImagePicker();
  late Map<String, Object?> jsonString = {};
  late RegistrationCard? registrationCard;
  late License? license;
  late XFile? pickedImage;

  @override
  void initState() {
    super.initState();
    getIdentifications();
  }

  void getIdentifications() async {
    final response = await apiService.getRequest(
        "idcard-service/summary/idcard", TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final tempRes = jsonData['response'];
      final idCardRes = tempRes['summaryRegistrationCard'];
      final licenseRes = tempRes['summaryLicense'];
      if (idCardRes != null) {
        registrationCard = getIdCardInfo(idCardRes);
      }

      if (licenseRes != null) {
        license = getDriveLicenseInfo(licenseRes);
      }
    }
  }

  RegistrationCard? getIdCardInfo(Map<String, dynamic> idCard) {
    print("신분증이 있어연");
    setState(() {
      isIdCardHave = true;
    });

    return RegistrationCard(
        registrationCardName: idCard["registrationCardName"],
        registrationCardPersonalNumber:
            idCard["registrationCardPersonalNumber"]);
  }

  License? getDriveLicenseInfo(Map<String, dynamic> license) {
    print("면허증이 있어연");
    setState(() {
      isLicenseHave = true;
    });

    return License(
        licenseName: license["licenseName"],
        licensePersonalNumber: license["licensePersonalNumber"]);
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        Row(
          children: [
            introText(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 15.0),
              child: SvgPicture.asset(
                "assets/id.svg",
                height: 45,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.03),
        titleText(text: "주민등록증"),
        isIdCardHave
            ? contentBox(
                context,
                Column(
                  children: [
                    Expanded(
                      child: Text(
                        registrationCard!.registrationCardName,
                        style: TextStyle(color: Color(0xFF989898)),
                      ),
                    ),
                    Text(
                      registrationCard!.registrationCardPersonalNumber,
                      style: TextStyle(color: Color(0xFF989898)),
                    ),
                    SizedBox(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.7,
                      child: registerButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServiceAggreementPage(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/id/create');
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
              )
            : contentBox(
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
                                    arguments: ImageAndData(
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
        SizedBox(height: screenHeight * 0.03),
        titleText(text: "운전면허증"),
        isLicenseHave
            ? contentBox(
                context,
                // 여기에 면허정보가 들어가야함. 클릭하면 상세정보 이동.
                Column(
                  children: [
                    Expanded(
                      child: Text(
                        "등록된 운전면허증이 있습니다",
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
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/drive/id/create');
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
              )
            : contentBox(
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
                                    arguments: ImageAndData(
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
              )
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
                "디지털 신분증",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF00496F),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Text(
                  "으로",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "사용할 수 있어요",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget titleText({required String text}) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0, left: screenWidth * 0.1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 21,
          ),
        ),
      ),
    );
  }
}
