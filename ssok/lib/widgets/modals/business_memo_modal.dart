import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

class BusinessMemoModal extends StatefulWidget {
  const BusinessMemoModal({
    Key? key,
    required this.closeOnPress,
    required this.content,
    required this.exchangeSeq
  }) : super(key: key);

  final Function() closeOnPress;
  final String content;
  final int exchangeSeq;
  
  @override
  State<BusinessMemoModal> createState() => _BusinessMemoModalState();
}

class _BusinessMemoModalState extends State<BusinessMemoModal> {
  final TextEditingController controller = TextEditingController();
  ApiService apiService = ApiService();
  late int exchangeSeq;

  @override
  void initState() {
    super.initState();
    controller.text = widget.content;
    exchangeSeq = widget.exchangeSeq;
  }


  void updateNameCardMemo() async{
    print(controller.text);
    print(controller.text == "");
    print(exchangeSeq);
    
    final response = await apiService.postRawRequest('namecard-service/memo/$exchangeSeq', controller.text, TokenManager().accessToken);
    if (response.statusCode != 200) {
      print("실패");
      print(response.body);
    }

  }

  Future<bool> isUpdateMemo() async{
    bool res = true;
    await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("메모 수정"),
            content: Text(
              "메모를 수정 하시겠습니까 ? ",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: <Widget>[  
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text("확인"),
              ),
              TextButton(
                onPressed: () { 
                  Navigator.of(context).pop();
                  res = false;
                  },
                child: Text("취소"),
              ),
            ],
          ),
        );
    return res;
  }

  void printFuc(String text){
    print("text를 출력하겠습니다.");
    print(text);

  }

  bool _update = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 0.58,
        width: screenWidth * 0.40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.055,
                  alignment: Alignment.center,
                  child: Text(
                    "메모",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: widget.closeOnPress,
                    icon: Icon(Icons.close),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                onChanged: (newValue) {},
                onSubmitted: (text) {}, // Enter를 누를 때 실행되는 함수
                readOnly: _update,
                maxLines: 13,
                decoration: InputDecoration(
                  // InputDecoration안에서 설정
                  hintText: "메모를 입력하세요",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            _update
                ? Align(
                    alignment: Alignment.center,
                    child: modalButton("수정", () {
                      setState(() {
                        _update = false;
                      });
                    }))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      modalButton("등록", () async {
                        if(await isUpdateMemo()){
                          updateNameCardMemo();
                          setState(() {
                          _update = true;
                        });
                        }
                        
                      }),
                      SizedBox(width: screenWidth * 0.08),
                      modalButton("초기화", () {
                        controller.text = "";
                      }),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget modalButton(String text, Function() onPressed) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          screenWidth * 0.18,
          screenHeight * 0.045,
        ),
        backgroundColor: Color(0xFF00ADEF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
