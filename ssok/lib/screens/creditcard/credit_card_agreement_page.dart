import 'package:flutter/material.dart';
import 'package:ssok/widgets/identfications/single_checkbox.dart';
import 'package:ssok/widgets/identfications/total_checkbox.dart';

class CreditCardAgreementPage extends StatefulWidget {
  final void Function() onTap;
  const CreditCardAgreementPage({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  @override
  State<CreditCardAgreementPage> createState() => _CreditCardAgreementPage();
}

class _CreditCardAgreementPage extends State<CreditCardAgreementPage> {
  bool isTotalAgree = false;
  bool isAgree1 = false;
  bool isAgree2 = false;
  bool isAgree3 = false;
  bool isAgree4 = false;
  bool isAgree5 = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    void Function() onTap = widget.onTap;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    void isAllAgree() {
      if (isAgree1 && isAgree2 && isAgree3 && isAgree4 && isAgree5) {
        if (!isTotalAgree) {
          setState(() {
            isTotalAgree = !isTotalAgree;
          });
        }
      } else {
        if (isTotalAgree) {
          setState(() {
            isTotalAgree = !isTotalAgree;
          });
        }
      }
    }

    void isComplete() {
      if (isAgree1 && isAgree2 && isAgree3 && isAgree4) {
        setState(() {
          isChecked = true;
        });
      } else {
        setState(() {
          isChecked = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "약관동의",
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
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.04),
          TotalCheckbox(
            label: '약관에 전체동의 (선택사항 포함)',
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            value: isTotalAgree,
            onChanged: (bool newValue) {
              setState(() {
                isTotalAgree = newValue;
                isAgree1 = newValue;
                isAgree2 = newValue;
                isAgree3 = newValue;
                isAgree4 = newValue;
                isAgree5 = newValue;
                isComplete();
              });
            },
          ),
          Divider(
            height: 20,
          ),
          SingleCheckbox(
            isActive: isAgree1,
            activeColor: Colors.green,
            inactiveColor: const Color(0xFF676767),
            label: "(필수) SSOK 서비스 이용 약관",
            onTap: () {
              setState(() {
                isAgree1 = !isAgree1;
                isAllAgree();
                isComplete();
              });
            },
          ),
          SingleCheckbox(
            isActive: isAgree2,
            activeColor: Colors.green,
            inactiveColor: const Color(0xFF676767),
            label: "(필수) 개인정보 수집 및 이용에 대한 동의",
            onTap: () {
              setState(() {
                isAgree2 = !isAgree2;
                isAllAgree();
                isComplete();
              });
            },
          ),
          SingleCheckbox(
            isActive: isAgree3,
            activeColor: Colors.green,
            inactiveColor: const Color(0xFF676767),
            label: "(필수) 개인정보 제3자 제공 동의",
            onTap: () {
              setState(() {
                isAgree3 = !isAgree3;
                isAllAgree();
                isComplete();
              });
            },
          ),
          SingleCheckbox(
            isActive: isAgree4,
            activeColor: Colors.green,
            inactiveColor: const Color(0xFF676767),
            label: "(필수) 개인정보 위탁 동의",
            onTap: () {
              setState(() {
                isAgree4 = !isAgree4;
                isAllAgree();
                isComplete();
              });
            },
          ),
          SingleCheckbox(
            isActive: isAgree5,
            activeColor: Colors.green,
            inactiveColor: const Color(0xFF676767),
            label: "(선택) 위치기반서비스 이용약관",
            onTap: () {
              setState(() {
                isAgree5 = !isAgree5;
                isAllAgree();
                isComplete();
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: isChecked ? Color(0xFF00496F) : Color(0xFF676767),
        child: InkWell(
          splashColor: Color(0xFF00496F),
          onTap: isChecked ? onTap : null,
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.07,
            alignment: Alignment.center,
            child: Text(
              "동의하고 계속하기",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
