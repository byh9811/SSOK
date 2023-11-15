import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssok/screens/loading/transfer_loading_page.dart';
import 'package:ssok/widgets/businesscards/childrens/content_by_card.dart';
import 'package:ssok/widgets/frequents/main_button.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';
import 'package:ssok/widgets/modals/business_create_modal.dart';
import 'package:ssok/widgets/modals/business_update_modal.dart';

import '../../dto/recognized_namecard.dart';
import '../../http/http.dart';
import '../../http/token_manager.dart';

class BusinessCardCameraCreatePage extends StatefulWidget {
  final String? apiUrl;

  const BusinessCardCameraCreatePage({super.key, String? this.apiUrl});

  @override
  State<BusinessCardCameraCreatePage> createState() =>
      _BusinessCardCameraCreatePageState();
}

class _BusinessCardCameraCreatePageState
    extends State<BusinessCardCameraCreatePage> {
  ImageAndNamecardData? args;
  late XFile image;
  Map<String, dynamic> businessCardInfo = {};
  String? apiUrl = 'namecard-service/';

  ApiService apiService = ApiService();

  void register() async {
    if (businessCardInfo["namecardName"].isNotEmpty &&
        businessCardInfo["namecardCompany"].isNotEmpty
        // businessCardInfo["namecardJob"].isNotEmpty &&
        // businessCardInfo["namecardAddress"].isNotEmpty &&
        // businessCardInfo["namecardPhone"].isNotEmpty &&
        // businessCardInfo["namecardTel"].isNotEmpty &&
        // businessCardInfo["namecardFax"].isNotEmpty &&
        // businessCardInfo["namecardEmail"].isNotEmpty &&
        // businessCardInfo["namecardWebsite"].isNotEmpty
        ) {
      Map<String, String> requestData = {
        "namecardName": businessCardInfo["namecardName"],
        "namecardJob": businessCardInfo["namecardJob"],
        "namecardCompany": businessCardInfo["namecardCompany"],
        "namecardAddress": businessCardInfo["namecardAddress"],
        "namecardPhone": businessCardInfo["namecardPhone"],
        "namecardTel": businessCardInfo["namecardTel"],
        "namecardFax": businessCardInfo["namecardFax"],
        "namecardEmail": businessCardInfo["namecardEmail"],
        "namecardWebsite": businessCardInfo["namecardWebsite"],
      };
      var bytes = await File(image.path).readAsBytes();
      final response = await apiService.postRequestWithFile(
          args!.apiUrl,
          'namecardCreateRequest',
          jsonEncode(requestData),
          TokenManager().accessToken,
          bytes);
      Map<String, dynamic> jsonData = jsonDecode(response);
      if (jsonData["success"]) {
        // ignore: use_build_context_synchronously
        showSuccessDialog(context, "명함", "명함이 생성되었습니다", () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("명함생성 실패"),
        ));
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1);
        throw Exception('Failed to load');
      }
    } else {
      showSuccessDialog(context, "명함 생성", "이름과 회사명은 필수입니다!", () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      // ModalRoute.of(context)!.settings.arguments를 통해 데이터를 읽어옵니다.
      args = ModalRoute.of(context)!.settings.arguments as ImageAndNamecardData;

      // 읽어온 데이터를 출력하거나 다른 초기화 작업을 수행할 수 있습니다.
      if (args != null) {
        print("데이터 읽음");
        print(args!.data); // 'value'
        print(args!.data.namecardName); // 'value'
        print(args!.data.namecardAddress); // 'value'

        setState(() {
          businessCardInfo["namecardName"] = args!.data.namecardName ?? "";
          businessCardInfo["namecardJob"] = args!.data.namecardJob ?? "";
          businessCardInfo["namecardCompany"] =
              args!.data.namecardCompany ?? "";
          businessCardInfo["namecardAddress"] =
              args!.data.namecardAddress ?? "";
          businessCardInfo["namecardPhone"] = args!.data.namecardPhone ?? "";
          businessCardInfo["namecardTel"] = args!.data.namecardTel ?? "";
          businessCardInfo["namecardFax"] = args!.data.namecardFax ?? "";
          businessCardInfo["namecardEmail"] = args!.data.namecardEmail ?? "";
          businessCardInfo["namecardWebsite"] =
              args!.data.namecardWebsite ?? "";
          image = args!.image;
        });
      } else {
        print("데이터 못읽음");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "명함 ${args!.type}",
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // 원하는 색상으로 변경
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 9 / 5,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Container(
                    child: Image.file(File(image!.path)),
                  ),
                ),
              ),
              Stack(
                children: [
                  ContentBoxByCard(
                    heightSize: 0.25,
                    onPress: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: screenWidth,
                                  height: screenHeight,
                                  color: Colors.transparent,
                                ),
                                Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: BusinessUpdateModal(
                                    selectedCardInfo: {
                                      '이름': businessCardInfo['namecardName'],
                                      '회사': businessCardInfo['namecardCompany'],
                                      '직책': businessCardInfo['namecardJob'],
                                      '주소': businessCardInfo['namecardAddress'],
                                    },
                                    onCardInfoChanged: (newValue) {
                                      print("newValue : $newValue");
                                      setState(() {
                                        businessCardInfo['namecardName'] =
                                            newValue['이름'];
                                        businessCardInfo['namecardCompany'] =
                                            newValue['회사'];
                                        businessCardInfo['namecardJob'] =
                                            newValue['직책'];
                                        businessCardInfo['namecardAddress'] =
                                            newValue['주소'];
                                      });
                                    },
                                    heightSize: 0.63,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      ContentByCard(
                        title: "이름",
                        content: businessCardInfo['namecardName'] ?? "",
                      ),
                      ContentByCard(
                        title: "직책(회사)",
                        content: (businessCardInfo['namecardJob'] ?? "") +
                            " / " +
                            (businessCardInfo['namecardCompany'] ?? ""),
                      ),
                      ContentByCard(
                        title: "주소",
                        content: businessCardInfo['namecardAddress'] ?? "",
                      )
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  ContentBoxByCard(
                    heightSize: 0.32,
                    onPress: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: screenWidth,
                                  height: screenHeight,
                                  color: Colors.transparent,
                                ),
                                Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: BusinessUpdateModal(
                                    selectedCardInfo: {
                                      '휴대폰':
                                          businessCardInfo['namecardPhone'] ??
                                              "",
                                      '회사번호':
                                          businessCardInfo['namecardTel'] ?? "",
                                      'FAX':
                                          businessCardInfo['namecardFax'] ?? "",
                                      '이메일':
                                          businessCardInfo['namecardEmail'] ??
                                              "",
                                    },
                                    onCardInfoChanged: (newValue) {
                                      print("newValue : $newValue");
                                      setState(() {
                                        businessCardInfo['namecardPhone'] =
                                            newValue['휴대폰'];
                                        businessCardInfo['namecardTel'] =
                                            newValue['회사번호'];
                                        businessCardInfo['namecardFax'] =
                                            newValue['FAX'];
                                        businessCardInfo['namecardEmail'] =
                                            newValue['이메일'];
                                      });
                                    },
                                    heightSize: 0.63,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      ContentByCard(
                        title: "휴대폰",
                        content: businessCardInfo['namecardPhone'] ?? "",
                      ),
                      ContentByCard(
                        title: "회사번호",
                        content: businessCardInfo['namecardTel'] ?? "",
                      ),
                      ContentByCard(
                        title: "FAX",
                        content: businessCardInfo['namecardFax'] ?? "",
                      ),
                      ContentByCard(
                        title: "이메일",
                        content: businessCardInfo['namecardEmail'] ?? "",
                      )
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  ContentBoxByCard(
                      heightSize: 0.1,
                      onPress: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: screenWidth,
                                    height: screenHeight,
                                    color: Colors.transparent,
                                  ),
                                  Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                    child: BusinessUpdateModal(
                                      selectedCardInfo: {
                                        '홈페이지': businessCardInfo[
                                                'namecardWebsite'] ??
                                            ""
                                      },
                                      onCardInfoChanged: (newValue) {
                                        print("newValue : $newValue");
                                        setState(() {
                                          businessCardInfo['namecardWebsite'] =
                                              newValue['홈페이지'];
                                        });
                                      },
                                      heightSize: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      ContentByCard(
                        title: "홈페이지",
                        content: businessCardInfo['namecardWebsite'] ?? "",
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              MainButton(
                title: args!.type,
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false, // 배경이 투명해야 함을 나타냅니다
                      pageBuilder: (BuildContext context, _, __) {
                        return TransferLoadingPage();
                      },
                    ),
                  );
                  register();
                },
                color: "0xFF00ADEF",
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

// class BusinessCardCameraCreatePage extends StatelessWidget {
//   const BusinessCardCameraCreatePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Map<String, dynamic> businessCardInfo = {
//       'namecardName': '홍길동',
//       'namecardJob': 'Android Developer',
//       'namecardCompany': 'Dev Team',
//       'namecardAddress': '경기도 성남시 분당구 ...',
//       'namecardPhone': '010-1111-2222',
//       'namecardTel': '010-1111-2222',
//       'namecardFax': '050-000-2222',
//       'namecardEmail': 'i0364842@naver.com',
//       'namecardWebsite': 'samsung.com',
//     };
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: true,
//         title: Text(
//           "명함 상세",
//           style: TextStyle(
//             fontSize: 19,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(
//           color: Colors.black, // 원하는 색상으로 변경
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
//           child: Column(
//             children: [
//               AspectRatio(
//                 aspectRatio: 9 / 5,
//                 child: Padding(
//                   padding: EdgeInsets.all(screenWidth * 0.04),
//                   child: Container(
//                     color: Colors.amber,
//                   ),
//                 ),
//               ),
//               Stack(
//                 children: [
//                   ContentBoxByCard(
//                     heightSize: 0.25,
//                     onPress: () {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) {
//                           return GestureDetector(
//                             onTap: () {
//                               FocusScope.of(context).unfocus();
//                             },
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   width: screenWidth,
//                                   height: screenHeight,
//                                   color: Colors.transparent,
//                                 ),
//                                 Dialog(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(15.0)),
//                                   ),
//                                   child: BusinessUpdateModal(
//                                     selectedCardInfo: {
//                                       '이름': businessCardInfo['namecardName'] ??
//                                           "",
//                                       '직책':
//                                           businessCardInfo['namecardJob'] ?? "",
//                                       '회사':
//                                           businessCardInfo['namecardCompany'] ??
//                                               "",
//                                       '주소':
//                                           businessCardInfo['namecardAddress'] ??
//                                               "",
//                                     },
//                                     heightSize: 0.63,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: screenHeight * 0.015),
//                       ContentByCard(
//                         title: "이름",
//                         content: businessCardInfo['namecardName'] ?? "",
//                       ),
//                       ContentByCard(
//                         title: "직책(회사)",
//                         content: (businessCardInfo['namecardJob'] ?? "") +
//                             " / " +
//                             (businessCardInfo['namecardCompany'] ?? ""),
//                       ),
//                       ContentByCard(
//                         title: "주소",
//                         content: businessCardInfo['namecardAddress'] ?? "",
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//               Stack(
//                 children: [
//                   ContentBoxByCard(
//                     heightSize: 0.32,
//                     onPress: () {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) {
//                           return GestureDetector(
//                             onTap: () {
//                               FocusScope.of(context).unfocus();
//                             },
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   width: screenWidth,
//                                   height: screenHeight,
//                                   color: Colors.transparent,
//                                 ),
//                                 Dialog(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(15.0)),
//                                   ),
//                                   child: BusinessUpdateModal(
//                                     selectedCardInfo: {
//                                       '휴대폰':
//                                           businessCardInfo['namecardPhone'] ??
//                                               "",
//                                       '회사번호':
//                                           businessCardInfo['namecardTel'] ?? "",
//                                       'FAX':
//                                           businessCardInfo['namecardFax'] ?? "",
//                                       '이메일':
//                                           businessCardInfo['namecardEmail'] ??
//                                               "",
//                                     },
//                                     heightSize: 0.63,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: screenHeight * 0.015),
//                       ContentByCard(
//                         title: "휴대폰",
//                         content: businessCardInfo['namecardPhone'] ?? "",
//                       ),
//                       ContentByCard(
//                         title: "회사번호",
//                         content: businessCardInfo['namecardTel'] ?? "",
//                       ),
//                       ContentByCard(
//                         title: "FAX",
//                         content: businessCardInfo['namecardFax'] ?? "",
//                       ),
//                       ContentByCard(
//                         title: "이메일",
//                         content: businessCardInfo['namecardEmail'] ?? "",
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//               Stack(
//                 children: [
//                   ContentBoxByCard(
//                       heightSize: 0.1,
//                       onPress: () {
//                         showDialog(
//                           barrierDismissible: false,
//                           context: context,
//                           builder: (context) {
//                             return GestureDetector(
//                               onTap: () {
//                                 FocusScope.of(context).unfocus();
//                               },
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                     width: screenWidth,
//                                     height: screenHeight,
//                                     color: Colors.transparent,
//                                   ),
//                                   Dialog(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(15.0)),
//                                     ),
//                                     child: BusinessUpdateModal(
//                                       selectedCardInfo: {
//                                         '홈페이지': businessCardInfo[
//                                                 'namecardWebsite'] ??
//                                             ""
//                                       },
//                                       heightSize: 0.3,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       }),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: screenHeight * 0.015),
//                       ContentByCard(
//                         title: "홈페이지",
//                         content: businessCardInfo['namecardWebsite'] ?? "",
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
class ContentBoxByCard extends StatelessWidget {
  const ContentBoxByCard({
    Key? key,
    required this.heightSize,
    required this.onPress,
  }) : super(key: key);

  final double heightSize;
  final Function() onPress;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight * heightSize,
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF474747),
            width: 1.0,
          ),
        ),
      ),
      child: IconButton(
        onPressed: onPress,
        icon: Icon(Icons.edit),
      ),
    );
  }
}
