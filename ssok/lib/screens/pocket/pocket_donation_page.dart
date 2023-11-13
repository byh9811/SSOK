import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/widgets/frequents/main_button.dart';

class PocketDonationPage extends StatefulWidget {
  const PocketDonationPage({super.key});

  @override
  State<PocketDonationPage> createState() => _PocketDonationPageState();
}

class _PocketDonationPageState extends State<PocketDonationPage> {


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "기부",
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
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
            OutgoingDonationList(),
            SizedBox(height: screenHeight * 0.06),
            // Divider(height: 1),
            // SizedBox(height: screenHeight * 0.01),
            // EndedDonationList(),
          ],
        ),
      ),
    );
  }
}

class OutgoingDonationList extends StatefulWidget {
  const OutgoingDonationList({super.key});

  @override
  State<OutgoingDonationList> createState() => _OutgoingDonationListState();
}

class _OutgoingDonationListState extends State<OutgoingDonationList> {
  
  ApiService apiService = ApiService();
  late List donateList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDonateList();
    donateList=[];
  }

  void getDonateList()async{
    final response = await apiService.getRequest('pocket-service/donate',TokenManager().accessToken);

    if (response.statusCode == 200) {
      print(jsonDecode(utf8.decode(response.bodyBytes))['response']);
      setState(() {
        donateList = jsonDecode(utf8.decode(response.bodyBytes))['response'];
      });
      print(donateList);
      print(donateList[0]);
      print(donateList[1]);
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final args = ModalRoute.of(context)!.settings.arguments as int;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 10.0),
          child: Text(
            "진행중인 기부목록",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        // 여기에 넣기
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: donateList.length,
          itemBuilder: (context, index) {
            var item = donateList[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: 10.0,
              ),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  border: Border.all(
                    color: Color(0xFF787878), // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                child: Column(
                  children: [
                    // Container(
                    //   height: screenHeight * 0.2,
                    //   decoration: BoxDecoration(
                    //     color: Colors.amber,
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(25.0),
                    //       topRight: Radius.circular(25.0),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      height: screenHeight * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: Image.network(
                        item['donateImage'], // 이미지 링크 필드로 변경
                        fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 조절
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01,
                      ),
                      child: Row(
                        children: [
                          Text(
                            item['donateTitle'], // 원하는 필드로 변경
                            style: TextStyle(fontSize: 16),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "나의 기부 금액 : "+item['memberTotalDonateAmt'].toString(), // 원하는 필드로 변경
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF818181),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: screenWidth * 0.04,
                        top: screenHeight * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.04),
                            child: Text(
                              "현재 누적 기부금", // 원하는 텍스트로 변경
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            item['donateTotalDonation'].toString(), // 원하는 필드로 변경
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if(item['donateState'])
                    MainButton(
                        title: "기부하기",
                        onPressed: () {
                          print(item);
                          item["pocketSaving"]=args;
                          print(item);
                          Navigator.of(context).pushNamed('/pocket/donation/send',arguments: item);
                        },
                      )

                      ,
                  ],
                ),
              ),
            );
          },
        ),
        
      ],
    );
  }
}

class EndedDonationList extends StatefulWidget {
  const EndedDonationList({super.key});

  @override
  State<EndedDonationList> createState() => _EndedDonationListState();
}

class _EndedDonationListState extends State<EndedDonationList> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 10.0),
          child: Text(
            "종료된 기부목록",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              border: Border.all(
                color: Color(0xFF787878), // 테두리 색상
                width: 0.5, // 테두리 두께
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
      ],
    );
  }
}
