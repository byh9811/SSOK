import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/loading/transfer_loading_page.dart';
import 'package:ssok/screens/main_page.dart';

import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_down.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_left.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_right.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_up.dart';
import 'package:ssok/widgets/frequents/confirm.dart';
import 'package:ssok/widgets/frequents/main_button.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';

class BusinessCardSelfCreatePage extends StatefulWidget {
  const BusinessCardSelfCreatePage({Key? key}) : super(key: key);

  @override
  State<BusinessCardSelfCreatePage> createState() =>
      _BusinessCardSelfCreatePageState();
}

class _BusinessCardSelfCreatePageState
    extends State<BusinessCardSelfCreatePage> {
  int currentOffsetIndex = -1;
  String name = "";
  String registeredName = "";
  String job = "";
  String registeredJob = "";
  String company = "";
  String registeredCompany = "";
  String address = "";
  String registeredAddress = "";
  String phone = "";
  String registeredPhone = "";
  String tel = "";
  String registeredTel = "";
  String fax = "";
  String registeredFax = "";
  String email = "";
  String registeredEmail = "";
  String website = "";
  String registeredWebsite = "";

  List<bool> isCheckedList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  late ApiService apiService = ApiService();
  late String apiUrl;
  late String titleType;

  void isCheckedChange() {
    int temp = currentOffsetIndex;
    for (int i = 0; i <= isCheckedList.length; i++) {
      temp++;
      if (temp >= isCheckedList.length) {
        temp = 0;
      }
      if (isCheckedList[temp]) {
        setState(() {
          currentOffsetIndex = temp;
        });
        return;
      }
    }
    setState(() {
      currentOffsetIndex = -1;
    });
  }

  void isCheckedFocus(int num) {
    setState(() {
      currentOffsetIndex = num;
    });
  }

  List<double> fontSizes = [13, 13, 13, 13, 13, 13, 13, 13, 13];
  void isPlus(int num) {
    fontSizes[num]++;
  }

  void isMinus(int num) {
    fontSizes[num]--;
  }
  // late File myCard;

  Future<Uint8List> capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // File? myCard = await saveImage(pngBytes);
    return pngBytes;
    // print(pngBytes);
    // String appDocPath = 'C:/SSAFY';
    // File imgFile = File('$appDocPath/screenshot.png');
    // imgFile.writeAsBytes(pngBytes);
    // print("FINISH CAPTURE ${imgFile.path}");
    // saveImage(pngBytes);
  }

  Future<File?> saveImage(Uint8List imageBytes) async {
    // 외부 저장소 디렉터리 찾기
    final directory = await getExternalStorageDirectory();

    if (directory != null) {
      // 디렉터리가 존재하면 파일 경로 생성
      final imagePath = '${directory.path}/mycard.png';

      // 파일로 변환하여 저장
      File imgFile = File(imagePath);
      await imgFile.writeAsBytes(imageBytes);

      print("Image saved at: $imagePath");
      return imgFile;
    } else {
      print("Directory not found");
    }
    return null;
  }

  // Future<File> createFile(Uint8List pngBytes) async {
  //   const filename = 'myBusinesscard.png';
  //   final path = (await getApplicationDocumentsDirectory()).path;
  //   final file = File('$path/$filename');
  //   await file.writeAsBytes(pngBytes);
  //   return file;
  // }

  void createBusinessCard(Uint8List bytes) async {
    Map<String, String> namecardCreateRequest = {
      "namecardName": registeredName,
      "namecardEmail": registeredEmail,
      "namecardCompany": registeredCompany,
      "namecardJob": registeredJob,
      "namecardAddress": registeredAddress,
      "namecardPhone": registeredPhone,
      "namecardTel": registeredTel,
      "namecardFax": registeredFax,
      "namecardWebsite": registeredWebsite
    };

    final response = await apiService.postRequestWithFile(
        apiUrl,
        "namecardCreateRequest",
        jsonEncode(namecardCreateRequest),
        TokenManager().accessToken,
        bytes);
    // print("response : $response");
    Map<String, dynamic> jsonData = jsonDecode(response);
    print(jsonData['success']);
    print(jsonData['success'].runtimeType);
    if (jsonData['success']) {
      print(jsonData);
      // ignore: use_build_context_synchronously
      showSuccessDialog(context, "명함", "명함이 ${titleType}되었습니다", () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("명함${titleType} 실패"),
      ));
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1);
      throw Exception('Failed to load');
    }
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  late final globalKey;
  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    globalKey = GlobalKey();

    Future.delayed(Duration.zero, () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Map<String, dynamic>? arguments =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        if (arguments != null) {
          apiUrl = arguments['apiUrl'] as String;
          titleType = arguments['type'] as String;
        } else {
          apiUrl = 'namecard-service/'; // 기본값 설정
          titleType = "등록";
        }
        print("===================================");
        print(apiUrl);
        print(titleType);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            "명함 제작",
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
        body: GestureDetector(
          onTap: () {
            // FocusScope를 사용하여 현재의 포커스를 제거하여 키보드를 숨깁니다.
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                BusinessCardBox(
                  onTap: () {
                    isCheckedChange();
                  },
                  fontSizes: fontSizes,
                  name: registeredName,
                  job: registeredJob,
                  company: registeredCompany,
                  address: registeredAddress,
                  phone: registeredPhone,
                  tel: registeredTel,
                  fax: registeredFax,
                  email: registeredEmail,
                  website: registeredWebsite,
                  currentOffsetIndex: currentOffsetIndex,
                  globalKey: globalKey,
                ),
                SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    BusinessCardText(
                      title: "이름 *",
                      hintContent: "홍길동",
                      updateValue: (newValue) {
                        setState(() {
                          name = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[0] = !isCheckedList[0];
                          if (!isCheckedList[0]) {
                            registeredName = "";
                            isCheckedChange();
                          } else {
                            registeredName = name;
                            isCheckedFocus(0);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(0);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(0);
                        });
                      },
                      isChecked: isCheckedList[0],
                    ),
                    BusinessCardText(
                      title: "회사 *",
                      hintContent: "Samsung",
                      updateValue: (newValue) {
                        setState(() {
                          company = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[2] = !isCheckedList[2];
                          if (!isCheckedList[2]) {
                            registeredCompany = "";
                            isCheckedChange();
                          } else {
                            registeredCompany = company;
                            isCheckedFocus(2);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(2);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(2);
                        });
                      },
                      isChecked: isCheckedList[2],
                    ),
                    BusinessCardText(
                      title: "직책 / 업무",
                      hintContent: "Developer",
                      updateValue: (newValue) {
                        setState(() {
                          job = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[1] = !isCheckedList[1];
                          if (!isCheckedList[1]) {
                            registeredJob = "";
                            isCheckedChange();
                          } else {
                            registeredJob = job;
                            isCheckedFocus(1);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(1);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(1);
                        });
                      },
                      isChecked: isCheckedList[1],
                    ),
                    BusinessCardText(
                      title: "주소",
                      hintContent: "서울특별시 강남구...",
                      updateValue: (newValue) {
                        setState(() {
                          address = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[3] = !isCheckedList[3];
                          if (!isCheckedList[3]) {
                            registeredAddress = "";
                            isCheckedChange();
                          } else {
                            registeredAddress = address;
                            isCheckedFocus(3);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(3);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(3);
                        });
                      },
                      isChecked: isCheckedList[3],
                    ),
                    BusinessCardText(
                      title: "휴대폰",
                      hintContent: "01012345678",
                      updateValue: (newValue) {
                        setState(() {
                          phone = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[4] = !isCheckedList[4];
                          if (!isCheckedList[4]) {
                            registeredPhone = "";
                            isCheckedChange();
                          } else {
                            registeredPhone = phone;
                            isCheckedFocus(4);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(4);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(4);
                        });
                      },
                      isChecked: isCheckedList[4],
                    ),
                    BusinessCardText(
                      title: "회사번호",
                      hintContent: "021234567",
                      updateValue: (newValue) {
                        setState(() {
                          tel = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[5] = !isCheckedList[5];
                          if (!isCheckedList[5]) {
                            registeredTel = "";
                            isCheckedChange();
                          } else {
                            registeredTel = tel;
                            isCheckedFocus(5);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(5);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(5);
                        });
                      },
                      isChecked: isCheckedList[5],
                    ),
                    BusinessCardText(
                      title: "FAX",
                      hintContent: "021234567",
                      updateValue: (newValue) {
                        setState(() {
                          fax = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[6] = !isCheckedList[6];
                          if (!isCheckedList[6]) {
                            registeredFax = "";
                            isCheckedChange();
                          } else {
                            registeredFax = fax;
                            isCheckedFocus(6);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(6);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(6);
                        });
                      },
                      isChecked: isCheckedList[6],
                    ),
                    BusinessCardText(
                      title: "이메일",
                      hintContent: "email@domain.com",
                      updateValue: (newValue) {
                        setState(() {
                          email = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[7] = !isCheckedList[7];
                          if (!isCheckedList[7]) {
                            registeredEmail = "";
                            isCheckedChange();
                          } else {
                            registeredEmail = email;
                            isCheckedFocus(7);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(7);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(7);
                        });
                      },
                      isChecked: isCheckedList[7],
                    ),
                    BusinessCardText(
                      title: "홈페이지",
                      hintContent: "www.homepage.com",
                      updateValue: (newValue) {
                        setState(() {
                          website = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[8] = !isCheckedList[8];
                          if (!isCheckedList[8]) {
                            registeredWebsite = "";
                            isCheckedChange();
                          } else {
                            registeredWebsite = website;
                            isCheckedFocus(8);
                          }
                        });
                      },
                      onPlus: () {
                        setState(() {
                          isPlus(8);
                        });
                      },
                      onMinus: () {
                        setState(() {
                          isMinus(8);
                        });
                      },
                      isChecked: isCheckedList[8],
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    MainButton(
                      title: "등록",
                      color: "0xFF00ADEF",
                      onPressed: () {
                        confirmDialog(
                          context,
                          "명함 ${titleType}",
                          "명함을 ${titleType}하시겠습니까?",
                          () async {
                            if (registeredName.isEmpty ||
                                registeredCompany.isEmpty) {
                              showSuccessDialog(
                                  context, "명함 ${titleType}", "이름과 회사명은 필수입니다!",
                                  () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                            } else {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false, // 배경이 투명해야 함을 나타냅니다
                                  pageBuilder: (BuildContext context, _, __) {
                                    return TransferLoadingPage();
                                  },
                                ),
                              );
                              Uint8List bytes = await capturePng();
                              createBusinessCard(bytes);
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}

class BusinessCardBox extends StatefulWidget {
  const BusinessCardBox({
    Key? key,
    required this.currentOffsetIndex,
    required this.onTap,
    required this.fontSizes,
    required this.name,
    required this.job,
    required this.company,
    required this.address,
    required this.phone,
    required this.tel,
    required this.fax,
    required this.email,
    required this.website,
    required this.globalKey,
  }) : super(key: key);

  final int currentOffsetIndex;
  final Function() onTap;
  final List<double> fontSizes;
  final String name;
  final String job;
  final String company;
  final String address;
  final String phone;
  final String tel;
  final String fax;
  final String email;
  final String website;
  final GlobalKey globalKey;

  @override
  State<BusinessCardBox> createState() => _BusinessCardBoxState();
}

class _BusinessCardBoxState extends State<BusinessCardBox> {
  int _draggingIndex = -1; // 드래그 중인 위젯의 인덱스를 추적하기 위한 변수

  // // 드래그 시작 시 호출될 메서드
  // void _onDragStarted(int index) {
  //   setState(() {
  //     _draggingIndex = index;
  //   });
  // }
  //
  // // 드래그 종료 시 호출될 메서드
  // void _onDragEnded() {
  //   setState(() {
  //     _draggingIndex = -1;
  //   });
  // }

  late List<String> values;

  List<BoxDecoration> decorations = [
    BoxDecoration(border: Border.all(color: Colors.transparent)),
    BoxDecoration(border: Border.all(color: Colors.transparent)),
    BoxDecoration(border: Border.all(color: Colors.transparent)),
    BoxDecoration(border: Border.all(color: Colors.transparent)),
    BoxDecoration(border: Border.all(color: Colors.transparent)),
    BoxDecoration(border: Border.all(color: Colors.transparent)),
    BoxDecoration(border: Border.all(color: Colors.transparent)),
    BoxDecoration(border: Border.all(color: Colors.transparent)),
    BoxDecoration(border: Border.all(color: Colors.transparent)),
  ];

  List<Offset> offsets = [
    Offset(60, 40),
    Offset(60, 60),
    Offset(60, 80),
    Offset(60, 100),
    Offset(60, 120),
    Offset(120, 40),
    Offset(120, 60),
    Offset(120, 80),
    Offset(120, 100),
  ];
  late double maxWidth;
  late double maxHeight;

  @override
  void initState() {
    super.initState();

    // 화면의 최대 너비와 높이를 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      maxWidth = MediaQuery.of(context).size.width * 0.54;
      maxHeight = MediaQuery.of(context).size.height * 0.16;
    });
  }

  int _currentPage = 0;

  final CarouselController _carouselController = CarouselController();
  List<Widget> templates = [
    Image.asset(
      'assets/business_card_templete0.png',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/business_card_templete1.png',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/business_card_templete2.png',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/business_card_templete3.png',
      fit: BoxFit.cover,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // DraggableText 위젯을 생성하는 메서드
    Widget _buildDraggableText(String text, int index) {
      return DraggableText(
        name: text,
        offset: offsets[index],
        fontSize: widget.fontSizes[index],
        decoration: decorations[index],
        onDragStarted: (newDeco) {
          setState(() {
            decorations[index] = newDeco;
          });
        },
        onDragEnded: (newDeco) {
          setState(() {
            decorations[index] = newDeco;
          });
        },
        onPositionChanged: (newOffset) {
          setState(() {
            offsets[index] = newOffset;
          });
        },
        // 다른 필요한 파라미터들...
      );
    }

    List<String> titleList = [
      "이름",
      "직책(업무)",
      "회사",
      "주소",
      "휴대폰",
      "회사번호",
      "FAX",
      "이메일",
      "홈페이지"
    ];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "※ 추가된 텍스트는 끌어당겨 이동",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "※ 버튼을 통해 타겟을 설정하고 화살표를 이용하여 상세 이동",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "※ +,- 버튼을 통해 글씨 크기 조정",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _currentPage == 0
                  ? null
                  : () {
                      _carouselController.previousPage();
                    },
              icon: Icon(
                Icons.chevron_left,
                color: _currentPage == 0 ? Colors.grey : Colors.black,
                size: 38,
              ),
            ),
            RepaintBoundary(
              key: widget.globalKey,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth * 0.73,
                    height: screenWidth * 0.73 * (5 / 9),
                    child: CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        enableInfiniteScroll: false,
                        height: screenWidth * 0.73 * (5 / 9),
                        aspectRatio: 9 / 5,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                      items: templates.map((template) {
                        return Builder(
                          builder: (BuildContext context) {
                            return template;
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  _buildDraggableText(widget.name, 0),
                  _buildDraggableText(widget.job, 1),
                  _buildDraggableText(widget.company, 2),
                  _buildDraggableText(widget.address, 3),
                  _buildDraggableText(widget.phone, 4),
                  _buildDraggableText(widget.tel, 5),
                  _buildDraggableText(widget.fax, 6),
                  _buildDraggableText(widget.email, 7),
                  _buildDraggableText(widget.website, 8),
                ],
              ),
            ),
            IconButton(
              onPressed: _currentPage == templates.length - 1
                  ? null
                  : () {
                      _carouselController.nextPage();
                    },
              icon: Icon(
                Icons.chevron_right,
                color: _currentPage == templates.length - 1
                    ? Colors.grey
                    : Colors.black,
                size: 38,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: widget.onTap,
              child: Container(
                alignment: Alignment.center,
                width: screenWidth * 0.2,
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.currentOffsetIndex == -1
                      ? "타겟 버튼"
                      : titleList[widget.currentOffsetIndex],
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(width: 5.0),
            KeyboardControllerUp(
              dx: widget.currentOffsetIndex == -1
                  ? 0
                  : offsets[widget.currentOffsetIndex].dx,
              dy: widget.currentOffsetIndex == -1
                  ? 0
                  : offsets[widget.currentOffsetIndex].dy,
              onDirectionChanged: (newDx, newDy) {
                setState(() {
                  if (widget.currentOffsetIndex != -1) {
                    offsets[widget.currentOffsetIndex] = Offset(newDx, newDy);
                  }
                });
              },
            ),
            KeyboardControllerDown(
              dx: widget.currentOffsetIndex == -1
                  ? 0
                  : offsets[widget.currentOffsetIndex].dx,
              dy: widget.currentOffsetIndex == -1
                  ? 0
                  : offsets[widget.currentOffsetIndex].dy,
              onDirectionChanged: (newDx, newDy) {
                setState(() {
                  if (widget.currentOffsetIndex != -1) {
                    offsets[widget.currentOffsetIndex] = Offset(newDx, newDy);
                  }
                });
              },
            ),
            KeyboardControllerLeft(
              dx: widget.currentOffsetIndex == -1
                  ? 0
                  : offsets[widget.currentOffsetIndex].dx,
              dy: widget.currentOffsetIndex == -1
                  ? 0
                  : offsets[widget.currentOffsetIndex].dy,
              onDirectionChanged: (newDx, newDy) {
                setState(() {
                  if (widget.currentOffsetIndex != -1) {
                    offsets[widget.currentOffsetIndex] = Offset(newDx, newDy);
                  }
                });
              },
            ),
            KeyboardControllerRight(
              dx: widget.currentOffsetIndex == -1
                  ? 0
                  : offsets[widget.currentOffsetIndex].dx,
              dy: widget.currentOffsetIndex == -1
                  ? 0
                  : offsets[widget.currentOffsetIndex].dy,
              onDirectionChanged: (newDx, newDy) {
                setState(() {
                  if (widget.currentOffsetIndex != -1) {
                    offsets[widget.currentOffsetIndex] = Offset(newDx, newDy);
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DraggableText extends StatefulWidget {
  final String name;
  final Offset offset;
  final double fontSize;
  final BoxDecoration? decoration; // 추가한 매개변수
  final Function(BoxDecoration)? onDragStarted; // 추가한 매개변수
  final Function(BoxDecoration)? onDragEnded; // 추가한 매개변수
  final Function(Offset)? onPositionChanged; // 필요한 매개변수

  DraggableText({
    Key? key,
    required this.name,
    required this.offset,
    required this.fontSize,
    this.decoration, // 추가
    required this.onDragStarted, // 추가
    required this.onDragEnded, // 추가
    required this.onPositionChanged,
  }) : super(key: key);

  @override
  State<DraggableText> createState() => DraggableTextState();
}

class DraggableTextState extends State<DraggableText> {
  late double maxWidth;
  late double maxHeight;

  @override
  void initState() {
    super.initState();
    // 화면의 최대 너비와 높이를 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      maxWidth = MediaQuery.of(context).size.width * 0.54;
      maxHeight = MediaQuery.of(context).size.height * 0.16;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.offset.dx,
      top: widget.offset.dy,
      child: GestureDetector(
        child: Container(
          decoration: widget.decoration, // 여기에 decoration 속성을 적용
          child: Text(
            widget.name,
            style: TextStyle(fontSize: widget.fontSize),
          ),
        ),
        onPanUpdate: (details) {
          final newOffset = Offset(
            (widget.offset.dx + details.delta.dx).clamp(0, maxWidth),
            (widget.offset.dy + details.delta.dy).clamp(0, maxHeight),
          );
          widget.onPositionChanged!(newOffset);
          final boxDecoration = BoxDecoration(
              border: Border.all(color: Colors.yellow, width: 2.0));
          widget.onDragStarted!(boxDecoration);
        },
        onPanEnd: (details) {
          final boxDecoration =
              BoxDecoration(border: Border.all(color: Colors.transparent));
          widget.onDragEnded!(boxDecoration);
        },
      ),
    );
  }
}

class BusinessCardText extends StatefulWidget {
  const BusinessCardText({
    Key? key,
    required this.title,
    required this.hintContent,
    required this.updateValue,
    required this.onTap,
    required this.onPlus,
    required this.onMinus,
    required this.isChecked,
  }) : super(key: key);

  final String title;
  final String hintContent;
  final Function(String) updateValue;
  final Function() onTap;
  final Function() onPlus;
  final Function() onMinus;
  final bool isChecked;

  @override
  State<BusinessCardText> createState() => _BusinessCardTextState();
}

class _BusinessCardTextState extends State<BusinessCardText> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.04),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          color: widget.isChecked
                              ? Color(0xFF9B9999)
                              : Color(0xFF00496F)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      enabled: !widget.isChecked,
                      onChanged: (newValue) {
                        // 사용자가 입력한 값을 value에 업데이트
                        setState(() {
                          widget.updateValue(newValue);
                        });
                      },
                      onSubmitted: (text) {}, // Enter를 누를 때 실행되는 함수
                      decoration: InputDecoration(
                        hintText: widget.hintContent,
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD7D0D0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.05),
              child: InkWell(
                onTap: widget.onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                      angle: widget.isChecked ? pi : 0,
                      child: Icon(
                        Icons.open_in_browser,
                        color: Color(0xFF4C4C4C),
                        size: 30,
                      ),
                    ),
                    Text(
                      widget.isChecked ? "추가 해제" : "추가",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: widget.isChecked
                            ? Color(0xFF727272)
                            : Color(0xFF4C4C4C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  //폰트 크기 조절
                  padding: EdgeInsets.only(),
                  child: InkWell(
                    onTap: widget.onPlus,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Color(0xFF4C4C4C),
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  //폰트 크기 조절
                  padding: EdgeInsets.only(),
                  child: InkWell(
                    onTap: widget.onMinus,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove,
                          color: Color(0xFF4C4C4C),
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
