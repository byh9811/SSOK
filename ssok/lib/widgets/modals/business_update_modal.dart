import 'package:flutter/material.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class BusinessUpdateModal extends StatefulWidget {
  const BusinessUpdateModal({
    Key? key,
    required this.selectedCardInfo,
    required this.heightSize,
  }) : super(key: key);

  final Map<String, dynamic> selectedCardInfo;
  final double heightSize;
  @override
  State<BusinessUpdateModal> createState() => _BusinessUpdateModalState();
}

class _BusinessUpdateModalState extends State<BusinessUpdateModal> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth * 0.75,
        height: screenHeight * widget.heightSize,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.057,
                  width: screenWidth * 0.75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    "정보 수정",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  height: screenHeight * 0.057,
                  width: screenWidth * 0.75,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF00496F), // 위쪽 테두리 색상
                        width: 1.0, // 테두리 두께
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Color(0xFF676767),
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            for (MapEntry<String, dynamic> entry
                in widget.selectedCardInfo.entries)
              ContentByCardUpdate(
                  title: entry.key,
                  content: entry.value,
                  addressType: entry.key == '주소' ? true : false),
            SizedBox(height: screenHeight * 0.05),
            MainButton(title: "수정",color: "0xFF00ADEF",onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class ContentByCardUpdate extends StatefulWidget {
  const ContentByCardUpdate({
    Key? key,
    required this.title,
    required this.content,
    required this.addressType,
  }) : super(key: key);
  final String title;
  final String content;
  final bool addressType;
  @override
  State<ContentByCardUpdate> createState() => _ContentByCardUpdateState();
}

class _ContentByCardUpdateState extends State<ContentByCardUpdate> {
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // values 중 하나를 선택 (예: 첫 번째 값)

    void searchAddress(BuildContext context) async {
      KopoModel? model = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RemediKopo(),
        ),
      );
      if (model != null) {
        final address = model.address ?? '';
        controller.value = TextEditingValue(
          text: address,
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.03,
        left: screenWidth * 0.07,
        right: screenWidth * 0.07,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(color: Color(0xFF9B9999)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: TextField(
              controller: controller,
              onChanged: (newValue) {
                setState(() {
                  controller.text = newValue;
                });
              },
              onSubmitted: (text) {}, // Enter를 누를 때 실행되는 함수
              readOnly: widget.addressType,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFD7D0D0),
                ),
                suffixIcon: widget.addressType
                    ? IconButton(
                        onPressed: () => searchAddress(context),
                        icon: Icon(Icons.search))
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
