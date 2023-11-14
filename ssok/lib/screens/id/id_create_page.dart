import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssok/screens/loading/transfer_loading_page.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';

import '../../http/http.dart';
import 'package:http/http.dart' as http;
import '../../http/token_manager.dart';
import '../../widgets/ids/not_registered_id_card.dart';

class IdCreatePage extends StatefulWidget {
  const IdCreatePage({super.key});

  @override
  State<IdCreatePage> createState() => _IdCreatePageState();
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

class _IdCreatePageState extends State<IdCreatePage> {
  ImageAndRegData? args;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _personalNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _authorityController = TextEditingController();

  ApiService apiService = ApiService();
  late String registrationCardName = "";
  late String registrationCardPersonalNumber = "";
  late String registrationCardAddress = "";
  late String registrationCardIssueDate = "";
  late String registrationCardAuthority = "";
  late XFile image;

  bool checkRegistrationCardName = false;
  bool checkRegistrationCardPersonalNumber = false;
  bool checkRegistrationCardAddress = false;
  bool checkRegistrationCardIssueDate = false;
  bool checkRegistrationCardAuthority = false;

  void register() async {
    print(_authorityController.text.isNotEmpty);
    print("hi");
    if (_nameController.text.isNotEmpty &&
        _personalNumberController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _issueDateController.text.isNotEmpty &&
        _authorityController.text.isNotEmpty) {
      Map<String, String> requestData = {
        "registrationCardName": _nameController.text,
        "registrationCardPersonalNumber": _personalNumberController.text,
        "registrationCardAddress": _addressController.text,
        "registrationCardIssueDate": _issueDateController.text,
        "registrationCardAuthority": _authorityController.text
      };
      var bytes = await File(image.path).readAsBytes();
      final response = await apiService.postRequestWithFile(
          'idcard-service/registration',
          'request',
          jsonEncode(requestData),
          TokenManager().accessToken,
          bytes);
      Map<String, dynamic> jsonData = jsonDecode(response);
      if (jsonData['success']) {
        // ignore: use_build_context_synchronously
        showSuccessDialog(context, "주민등록증", "등록에 성공했습니다", () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 0);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("등록 실패"),
        ));
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 0);
        throw Exception('Failed to load');
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)!.settings.arguments as ImageAndRegData;

      // 읽어온 데이터를 출력하거나 다른 초기화 작업을 수행할 수 있습니다.
      if (args != null) {
        print("데이터 읽음");
        print(args);

        _nameController.text = args!.data.registrationCardName ?? "";
        _personalNumberController.text =
            args!.data.registrationCardPersonalNumber ?? "";
        _addressController.text = args!.data.registrationCardAddress ?? "";
        _issueDateController.text = args!.data.registrationCardIssueDate ?? "";
        _authorityController.text = args!.data.registrationCardAuthority ?? "";
        image = args!.image;
      } else {
        print("데이터 못읽음");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "주민등록증 정보 입력",
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
      body: SingleChildScrollView(
        child: Column(
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
                      labelStyle:
                          TextStyle(color: Colors.teal, fontSize: 15.0))),
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
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              registrationCardName = value.trim();
                              checkRegistrationCardName =
                                  registrationCardName.isNotEmpty;
                            });
                          },
                        ),
                        TextField(
                          controller: _personalNumberController,
                          decoration: InputDecoration(labelText: '주민등록번호'),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              registrationCardPersonalNumber = value.trim();
                              checkRegistrationCardPersonalNumber =
                                  registrationCardPersonalNumber.isNotEmpty;
                            });
                          },
                        ),
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(labelText: '주소'),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              registrationCardAddress = value.trim();
                              checkRegistrationCardAddress =
                                  registrationCardAddress.isNotEmpty;
                            });
                          },
                        ),
                        TextField(
                          controller: _issueDateController,
                          decoration: InputDecoration(labelText: '발급일자'),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            registrationCardIssueDate = value.trim();
                            checkRegistrationCardIssueDate =
                                registrationCardIssueDate.isNotEmpty;
                          },
                        ),
                        TextField(
                          controller: _authorityController,
                          decoration: InputDecoration(labelText: '인증기관'),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              registrationCardAuthority = value.trim();
                              checkRegistrationCardAuthority =
                                  registrationCardAuthority.isNotEmpty;
                            });
                          },
                        ),
                        Row(children: [
                          Expanded(
                            child: ButtonTheme(
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      opaque: false, // 배경이 투명해야 함을 나타냅니다
                                      pageBuilder:
                                          (BuildContext context, _, __) {
                                        return TransferLoadingPage();
                                      },
                                    ),
                                  );
                                  register();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent),
                                child: Text(
                                  "등록",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ],
                    ),
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
