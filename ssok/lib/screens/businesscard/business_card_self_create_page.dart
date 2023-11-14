import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/screens/main_page.dart';

import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_down.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_left.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_right.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_up.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class BusinessCardSelfCreatePage extends StatefulWidget {
  const BusinessCardSelfCreatePage({super.key});

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
        'namecard-service/',
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
      showSnackbar("명함이 생성되었습니다.");
      Navigator.of(context).pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1);
    } else {
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
                      title: "이름",
                      hintContent: "이름 입력",
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
                      isChecked: isCheckedList[0],
                    ),
                    BusinessCardText(
                      title: "직책(업무)",
                      hintContent: "직책(업무) 입력",
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
                      isChecked: isCheckedList[1],
                    ),
                    BusinessCardText(
                      title: "회사",
                      hintContent: "회사 입력",
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
                      isChecked: isCheckedList[2],
                    ),
                    BusinessCardText(
                      title: "주소",
                      hintContent: "주소 입력",
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
                      isChecked: isCheckedList[3],
                    ),
                    BusinessCardText(
                      title: "휴대폰",
                      hintContent: "휴대폰 입력",
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
                      isChecked: isCheckedList[4],
                    ),
                    BusinessCardText(
                      title: "회사번호",
                      hintContent: "회사번호 입력",
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
                      isChecked: isCheckedList[5],
                    ),
                    BusinessCardText(
                      title: "FAX",
                      hintContent: "FAX 입력",
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
                      isChecked: isCheckedList[6],
                    ),
                    BusinessCardText(
                      title: "이메일",
                      hintContent: "이메일 입력",
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
                      isChecked: isCheckedList[7],
                    ),
                    BusinessCardText(
                      title: "홈페이지",
                      hintContent: "홈페이지 입력",
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
                      isChecked: isCheckedList[8],
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    MainButton(
                      title: "등록",
                      color: "0xFF00ADEF",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('명함 생성'),
                              content: Text('명함을 생성하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Uint8List bytes = await capturePng();
                                    createBusinessCard(bytes);
                                  },
                                  child: Text('생성'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, '취소');
                                  },
                                  child: Text('취소'),
                                ),
                              ],
                            );
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
  late List<String> values;
  List<Offset> offsets = [
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "※ 버튼을 통해 타겟을 설정하고 화살표를 이용하여 상세 이동",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chevron_left,
                size: 38,
              ),
            ),
            RepaintBoundary(
              key: widget.globalKey,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth * 0.65,
                    height: screenHeight * 0.18,
                    color: Colors.amber,
                  ),
                  DraggableText(
                    name: widget.name,
                    offset: offsets[0],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[0] = newOffset;
                      });
                    },
                  ),
                  DraggableText(
                    name: widget.job,
                    offset: offsets[1],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[1] = newOffset;
                      });
                    },
                  ),
                  DraggableText(
                    name: widget.company,
                    offset: offsets[2],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[2] = newOffset;
                      });
                    },
                  ),
                  DraggableText(
                    name: widget.address,
                    offset: offsets[3],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[3] = newOffset;
                      });
                    },
                  ),
                  DraggableText(
                    name: widget.phone,
                    offset: offsets[4],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[4] = newOffset;
                      });
                    },
                  ),
                  DraggableText(
                    name: widget.tel,
                    offset: offsets[5],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[5] = newOffset;
                      });
                    },
                  ),
                  DraggableText(
                    name: widget.fax,
                    offset: offsets[6],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[6] = newOffset;
                      });
                    },
                  ),
                  DraggableText(
                    name: widget.email,
                    offset: offsets[7],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[7] = newOffset;
                      });
                    },
                  ),
                  DraggableText(
                    name: widget.website,
                    offset: offsets[8],
                    onPositionChanged: (newOffset) {
                      setState(() {
                        offsets[8] = newOffset;
                      });
                    },
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chevron_right,
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
  const DraggableText({
    Key? key,
    required this.name,
    required this.offset,
    required this.onPositionChanged,
  }) : super(key: key);
  final String name;
  final Offset offset;
  final Function(Offset newOffset) onPositionChanged;

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
        child: Text(widget.name),
        onPanUpdate: (details) {
          final newOffset = Offset(
            (widget.offset.dx + details.delta.dx).clamp(0, maxWidth),
            (widget.offset.dy + details.delta.dy).clamp(0, maxHeight),
          );
          widget.onPositionChanged(newOffset);
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
    required this.isChecked,
  }) : super(key: key);

  final String title;
  final String hintContent;
  final Function(String) updateValue;
  final Function() onTap;
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
              padding: EdgeInsets.only(left: screenWidth * 0.1),
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
          ],
        ),
      ),
    );
  }
}
