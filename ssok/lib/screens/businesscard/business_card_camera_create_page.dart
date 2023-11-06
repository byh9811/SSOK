import 'package:flutter/material.dart';
import 'package:ssok/widgets/businesscards/childrens/content_by_card.dart';
import 'package:ssok/widgets/modals/business_update_modal.dart';

class BusinessCardCameraCreatePage extends StatelessWidget {
  const BusinessCardCameraCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> businessCardInfo = {
      'namecardName': '홍길동',
      'namecardJob': 'Android Developer',
      'namecardCompany': 'Dev Team',
      'namecardAddress': '경기도 성남시 분당구 ...',
      'namecardPhone': '010-1111-2222',
      'namecardTel': '010-1111-2222',
      'namecardFax': '050-000-2222',
      'namecardEmail': 'i0364842@naver.com',
      'namecardWebsite': 'samsung.com',
    };
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "명함 상세",
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
                    color: Colors.amber,
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
                                      '이름': businessCardInfo['namecardName'] ??
                                          "",
                                      '직책':
                                          businessCardInfo['namecardJob'] ?? "",
                                      '회사':
                                          businessCardInfo['namecardCompany'] ??
                                              "",
                                      '주소':
                                          businessCardInfo['namecardAddress'] ??
                                              "",
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
            ],
          ),
        ),
      ),
    );
  }
}

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
