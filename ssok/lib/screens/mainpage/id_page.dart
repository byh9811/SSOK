import 'dart:convert';

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

  RegistrationCard({
    required this.registrationCardName,
    required this.registrationCardPersonalNumber
  });
}

class License {
  final String licenseName;
  final String licensePersonalNumber;

  License({
    required this.licenseName,
    required this.licensePersonalNumber
  });
}

class _IdPageState extends State<IDPage> {
  ApiService apiService = ApiService();
  String? accessToken;
  bool isIdCardHave = false;
  bool isLicenseHave = false;
  final picker = ImagePicker();
  late XFile? pickedImage;

  @override
  void initState() {
    super.initState();
    getIdentifications();
  }

  void getIdentifications()async{
    final response = await apiService.getRequest("idcard-service/summary/idcard", TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    print(jsonData);
    if(response.statusCode == 200) {
      final idCard = jsonData['response.summaryRegistrationCard'];
      final license = jsonData['response.summaryLicense'];

      if(idCard!=null) {

        getIdCardInfo(idCard);
      }

      if(license!=null) {
        print("면허증이 있어연");
        setState(() {
          isLicenseHave=true;
        });
        getDriveLicenseInfo(license);
      }
    }
  }

  void getIdCardInfo(idCard)async{
    print("신분증이 있어연");
    setState(() {
      isIdCardHave=true;
    });

  }

  void getDriveLicenseInfo(license)async{
    final response = await apiService.getRequest("idcard-service/license", TokenManager().accessToken);
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    
    print(jsonData);
    if (response.statusCode == 200) {}
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    print(pickedFile);
    setState(() {
      pickedImage = pickedFile;
    });
  }

  void sendImage() async {
    final response = await apiService.postRequest(
        'idcard-service/scan/registration',
        {"img": "$pickedImage"},
        TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
    } else {
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
                        "등록된 주민등록증이 있습니다",
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
                        "등록된 주민등록증이 없습니다 ㄹㅇ루",
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
                                  _pickImage();
                                  //  Navigator.of(context)
                                  //     .pushReplacementNamed('/id/create');
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
                        "등록된 운전면허증이 없습니다 ㄹㅇ루",
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
