import 'dart:math';

import 'package:flutter/material.dart';

import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_down.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_left.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_right.dart';
import 'package:ssok/widgets/businesscards/childrens/keyboard_controller_up.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class SelfCreateCardPage extends StatefulWidget {
  const SelfCreateCardPage({super.key});

  @override
  State<SelfCreateCardPage> createState() => _SelfCreateCardPageState();
}

class _SelfCreateCardPageState extends State<SelfCreateCardPage> {
  int index = -1;
  String name = "";
  String registeredName = "";
  // bool isChecked = false;
  String job = "";
  String registeredJob = "";
  // bool isChecked2 = false;
  List<bool> isCheckedList = [false, false];

  void isCheckedChange() {
    int temp = index;
    for (int i = 0; i <= isCheckedList.length; i++) {
      temp++;
      if (temp >= isCheckedList.length) {
        temp = 0;
      }
      if (isCheckedList[temp]) {
        setState(() {
          index = temp;
        });
        return;
      }
    }
    setState(() {
      index = -1;
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
                  currentOffsetIndex: index,
                ),
                SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    BusinessCardText(
                      title: "이름",
                      hintContent: "이름 입력",
                      updateName: (newValue) {
                        setState(() {
                          name = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[0] = !isCheckedList[0];
                          if (!isCheckedList[0]) {
                            registeredName = "";
                          } else {
                            registeredName = name;
                          }
                        });
                        isCheckedChange();
                      },
                      isChecked: isCheckedList[0],
                    ),
                    BusinessCardText(
                      title: "직책(업무)",
                      hintContent: "직책(업무) 입력",
                      updateName: (newValue) {
                        setState(() {
                          job = newValue;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isCheckedList[1] = !isCheckedList[1];
                          if (!isCheckedList[1]) {
                            registeredJob = "";
                          } else {
                            registeredJob = job;
                          }
                        });
                        isCheckedChange();
                      },
                      isChecked: isCheckedList[1],
                    ),

                    // BusinessCardText(
                    //   title: "회사",
                    //   hintContent: "회사 입력",
                    // ),
                    // BusinessCardText(
                    //   title: "주소",
                    //   hintContent: "주소 입력",
                    // ),
                    // BusinessCardText(
                    //   title: "휴대폰",
                    //   hintContent: "휴대폰 입력",
                    // ),
                    // BusinessCardText(
                    //   title: "FAX",
                    //   hintContent: "FAX 입력",
                    // ),
                    // BusinessCardText(
                    //   title: "이메일",
                    //   hintContent: "이메일 입력",
                    // ),
                    // BusinessCardText(
                    //   title: "홈페이지",
                    //   hintContent: "홈페이지 입력",
                    // ),
                    SizedBox(height: screenHeight * 0.06),
                    MainButton(
                      title: "등록",
                      onPressed: () {},
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
  }) : super(key: key);

  final int currentOffsetIndex;
  final Function() onTap;
  final String name;
  final String job;

  @override
  State<BusinessCardBox> createState() => _BusinessCardBoxState();
}

class _BusinessCardBoxState extends State<BusinessCardBox> {
  late List<String> values;
  List<Offset> offsets = [Offset(0, 0), Offset(0, 0)];
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
    List<String> titleList = ["이름", "직책(업무)"];
    return Column(
      children: [
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
            Stack(
              children: [
                Container(
                  width: screenWidth * 0.65,
                  height: screenHeight * 0.18,
                  color: Colors.amber,
                ),
                // PositionedText(
                //   offset: offset,
                //   text: widget.name,
                // ),
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
              ],
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
        Row(
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
                child: Text(widget.currentOffsetIndex == -1
                    ? "${widget.currentOffsetIndex}"
                    : titleList[widget.currentOffsetIndex]),
              ),
            ),
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

// class PositionedText extends StatefulWidget {
//   const PositionedText({
//     Key? key,
//     required this.offset,
//     required this.text,
//   }) : super(key: key);
//   final String text;
//   final Offset offset;

//   @override
//   State<PositionedText> createState() => _PositionedTextState();
// }

// class _PositionedTextState extends State<PositionedText> {
//   Offset offset = Offset(0, 0);
//   late double maxWidth;
//   late double maxHeight;

//   @override
//   void initState() {
//     super.initState();
//     // 화면의 최대 너비와 높이를 가져옵니다.
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       maxWidth = MediaQuery.of(context).size.width * 0.54;
//       maxHeight = MediaQuery.of(context).size.height * 0.16;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       //스택의 자식 위치를 제어하는 위젯
//       //오프셋 클래스 하나의 위치를 x,y로 지정
//       left: widget.offset.dx,
//       top: widget.offset.dy,
//       child: GestureDetector(
//         child: Text(widget.text),
//         //제스처를 감지하는 위젯
//         onPanUpdate: (details) {
//           //드래그해서 이동한 위치만큼 Offset을 수정해서 State 변경
//           setState(() {
//             offset = Offset(
//               (widget.offset.dx + details.delta.dx).clamp(0, maxWidth),
//               (widget.offset.dy + details.delta.dy).clamp(0, maxHeight),
//             );
//           });
//         },
//       ),
//     );
//   }
// }

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
    required this.updateName,
    required this.onTap,
    required this.isChecked,
  }) : super(key: key);

  final String title;
  final String hintContent;
  final Function(String) updateName;
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
                      style: TextStyle(color: Color(0xFF9B9999)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      enabled: !widget.isChecked,
                      onChanged: (newValue) {
                        // 사용자가 입력한 값을 value에 업데이트
                        setState(() {
                          widget.updateName(newValue);
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
                      widget.isChecked ? "적용 해제" : "적용",
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
