import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssok/dto/license.dart';

import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

import 'package:ssok/widgets/ids/not_registered_drive_id_card.dart';
import 'package:ssok/widgets/ids/not_registered_id_card.dart';
import 'package:ssok/widgets/ids/registered_drive_id_card.dart';
import 'package:ssok/widgets/ids/registered_id_card.dart';

import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../dto/registration_card.dart';

class IDPage extends StatefulWidget {
  const IDPage({Key? key}) : super(key: key);

  @override
  State<IDPage> createState() => _IdPageState();
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
  int _current = 0;
  final CarouselController _controller = CarouselController();
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> imageSliders = [
      isIdCardHave ? RegisteredIdCard(registrationCard: registrationCard) : NotRegisteredIdCard(),
      isLicenseHave ? RegisteredDriveIdCard(license: license) : NotRegisteredDriveIdCard(),
    ];
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
        CarouselSlider(
          options: CarouselOptions(
              enlargeCenterPage: true,
              height: screenHeight * 0.57,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: imageSliders,
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageSliders.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 9.0,
                height: 9.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
        // isIdCardHave ? NotRegisteredIdCard() : RegisteredIdCard(),
        // SizedBox(height: screenHeight * 0.03),
        // titleText(text: "운전면허증"),
        // isLicenseHave
        //     ? RegisteredDriveIdCard(license: license)
        //     : NotRegisteredDriveIdCard(),
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
