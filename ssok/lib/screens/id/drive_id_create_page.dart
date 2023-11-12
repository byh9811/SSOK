import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../http/http.dart';
import '../../http/token_manager.dart';

class DriveIdCreatePage extends StatefulWidget {
  const DriveIdCreatePage({super.key});

  @override
  State<DriveIdCreatePage> createState() => _DriveIdCreatePageState();
}

class License {
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

  License(
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
  final License data;

  ImageAndData({required this.image, required this.data});
}

class _DriveIdCreatePageState extends State<DriveIdCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _personalNumberController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _renewStartDateController = TextEditingController();
  final TextEditingController _renewEndDateController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _authorityController = TextEditingController();

  ApiService apiService = ApiService();
  late String licenseName = "";
  late String licensePersonalNumber = "";
  late String licenseType = "";
  late String licenseAddress = "";
  late String licenseNumber = "";
  late String licenseRenewStartDate = "";
  late String licenseRenewEndDate = "";
  late String licenseCondition = "";
  late String licenseCode = "";
  late String licenseIssueDate = "";
  late String licenseAuthority = "";
  late XFile image;

  bool checkLicenseName = false;
  bool checkLicensePersonalNumber = false;
  bool checkLicenseAddress = false;
  bool checkLicenseIssueDate = false;
  bool checkLicenseAuthority = false;
  bool checkLicenseType = false;
  bool checkLicenseCode = false;
  bool checkLicenseNumber = false;
  bool checkLicenseRenewStartDate = false;
  bool checkLicenseRenewEndDate = false;
  bool checkLicenseCondition = false;

  void register() async {
    if (checkLicenseName &&
        checkLicensePersonalNumber &&
        checkLicenseAddress &&
        checkLicenseIssueDate &&
        checkLicenseAuthority &&
        checkLicenseType &&
        checkLicenseCode &&
        checkLicenseNumber &&
        checkLicenseRenewStartDate &&
        checkLicenseRenewEndDate &&
        checkLicenseCondition) {
      Map<String, String> requestData = {
        "licenseName": licenseName,
        "licensePersonalNumber": licensePersonalNumber,
        "licenseType": licenseType,
        "licenseAddress": licenseAddress,
        "licenseNumber": licenseNumber,
        "licenseRenewStartDate": licenseRenewStartDate,
        "licenseRenewEndDate": licenseRenewEndDate,
        "licenseCondition": licenseCondition,
        "licenseCode": licenseCode,
        "licenseIssueDate": licenseIssueDate,
        "licenseAuthority": licenseAuthority
      };
      var bytes = await File(image.path).readAsBytes();
      final response = await apiService.postRequestWithFile(
          'idcard-service/license',
          'licenseCreateRequest',
          jsonEncode(requestData),
          TokenManager().accessToken,
          bytes);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        throw Exception('Failed to load');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ImageAndData args =
    ModalRoute.of(context)!.settings.arguments as ImageAndData;
    licenseName = args.data.licenseName;
    licensePersonalNumber = args.data.licensePersonalNumber;
    licenseType = args.data.licenseType;
    licenseAddress = args.data.licenseAddress;
    licenseNumber = args.data.licenseNumber;
    licenseRenewStartDate = args.data.licenseRenewStartDate;
    licenseRenewEndDate = args.data.licenseRenewEndDate;
    licenseCondition = args.data.licenseCondition;
    licenseCode = args.data.licenseCode;
    licenseIssueDate = args.data.licenseIssueDate;
    licenseAuthority = args.data.licenseAuthority;
    image = args.image;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "운전면허증 정보 입력",
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Color(0xFF676767),
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // 원하는 색상으로 변경
        ),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Center(
            child: Image(
              image: AssetImage('assets/horizonLogo.png'),
              width: 200.0,
            ),
          ),
          Form(
              child: Theme(
                data: ThemeData(
                    primaryColor: Colors.grey,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                    padding: EdgeInsets.all(40.0),
                    // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                    // SingleChildScrollView으로 감싸 줌
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: '이름'),
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              setState(() {
                                licenseName = value.trim();
                                checkLicenseName =
                                    licenseName.isNotEmpty;
                              });
                            },
                          ),
                          TextField(
                            controller: _personalNumberController,
                            decoration: InputDecoration(labelText: '주민등록번호'),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                licensePersonalNumber = value.trim();
                                checkLicensePersonalNumber =
                                    licensePersonalNumber.isNotEmpty;
                              });
                            },
                          ),
                          TextField(
                            controller: _typeController,
                            decoration: InputDecoration(labelText: '타입'),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                licenseType = value.trim();
                                checkLicenseType =
                                    licenseType.isNotEmpty;
                              });
                            },
                          ),
                          TextField(
                            controller: _addressController,
                            decoration: InputDecoration(labelText: '주소'),
                            keyboardType: TextInputType.streetAddress,
                            onChanged: (value) {
                              setState(() {
                                licenseAddress = value.trim();
                                checkLicenseAddress =
                                    licenseAddress.isNotEmpty;
                              });
                            },
                          ),
                          TextField(
                            controller: _numberController,
                            decoration: InputDecoration(labelText: '면허 번호'),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              licenseNumber = value.trim();
                              checkLicenseNumber =
                                  licenseNumber.isNotEmpty;
                            },
                          ),
                          TextField(
                            controller: _renewStartDateController,
                            decoration: InputDecoration(labelText: '갱신 시작일'),
                            keyboardType: TextInputType.datetime,
                            onChanged: (value) {
                              licenseRenewStartDate = value.trim();
                              checkLicenseRenewStartDate =
                                  licenseRenewStartDate.isNotEmpty;
                            },
                          ),
                          TextField(
                            controller: _renewEndDateController,
                            decoration: InputDecoration(labelText: '갱신 종료일'),
                            keyboardType: TextInputType.datetime,
                            onChanged: (value) {
                              licenseRenewEndDate = value.trim();
                              checkLicenseRenewEndDate =
                                  licenseRenewEndDate.isNotEmpty;
                            },
                          ),
                          TextField(
                            controller: _conditionController,
                            decoration: InputDecoration(labelText: '조건'),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              licenseCondition = value.trim();
                              checkLicenseCondition =
                                  licenseCondition.isNotEmpty;
                            },
                          ),
                          TextField(
                            controller: _codeController,
                            decoration: InputDecoration(labelText: '코드'),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              licenseCode = value.trim();
                              checkLicenseCode =
                                  licenseCode.isNotEmpty;
                            },
                          ),
                          TextField(
                            controller: _issueDateController,
                            decoration: InputDecoration(labelText: '발급일자'),
                            keyboardType: TextInputType.datetime,
                            onChanged: (value) {
                              licenseIssueDate = value.trim();
                              checkLicenseIssueDate =
                                  licenseIssueDate.isNotEmpty;
                            },
                          ),
                          TextField(
                            controller: _authorityController,
                            decoration: InputDecoration(labelText: '인증기관'),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                licenseAuthority = value.trim();
                                checkLicenseAuthority =
                                    licenseAuthority.isNotEmpty;
                              });
                            },
                          ),
                          Row(children: [
                            Expanded(
                              child: ButtonTheme(
                                  height: 50.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // register();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent),
                                    child: Icon(
                                      Icons.accessibility,
                                      color: Colors.white,
                                      size: 35.0,
                                    ),
                                  )),
                            )
                          ]),
                        ],
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}