import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

class BusineessCardHistoryPage extends StatefulWidget {
  const BusineessCardHistoryPage({Key? key}) : super(key: key);

  @override
  State<BusineessCardHistoryPage> createState() => _BusineessCardHistoryPage();
}

class _BusineessCardHistoryPage extends State<BusineessCardHistoryPage> {
  
  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as int;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "타임라인",
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
      body: Column(children: [          Divider(
            height: 1,
            color: Colors.black,
            thickness: 1,
          ),BusinessCardHistory(exchangeSeq: args)]),
    );
  }
}

class BusinessCardHistory extends StatefulWidget{
  final int exchangeSeq;
  const BusinessCardHistory({Key? key, required this.exchangeSeq}) : super(key: key);

  @override
  State<BusinessCardHistory> createState() => _BusinessCardHistory(exchangeSeq);
}

class _BusinessCardHistory extends State<BusinessCardHistory>{

  final int exchangeSeq;
  _BusinessCardHistory(this.exchangeSeq);

  ApiService apiService = ApiService();

  late List<dynamic> imageList;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageList = []; // 초기값 설정
    getHistory();
  }

  void getHistory()async{
    final response = await apiService.getRequest("namecard-service/timeline/${exchangeSeq}", TokenManager().accessToken);
    final jsonData = jsonDecode(response.body);
    if(response.statusCode==200){
      setState(() {
        imageList = jsonData["response"];
      });
    }
    print("목록 조회");
    print(imageList.length);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.9,
      child: ListView.builder(
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenWidth *0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                  Stack(
                  alignment: Alignment.center,
                  children: [
                    if(imageList.length==1)Container(
                      width:100,
                      height:230,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/1.PNG'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if(imageList.length!=1 && index==0)Container(
                      width:100,
                      height:230,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/2.PNG'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if(imageList.length>=3 && index!=0 && index!=imageList.length-1)Container(
                      width:100,
                      height:230,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/3.PNG'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if(index!=0 && index==imageList.length-1)Container(
                      width:100,
                      height:230,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/4.PNG'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Text(
                      '명함 생성일\n2022-10-31',
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // 그림자 색상과 투명도
                        spreadRadius: 5, // 그림자 확산 정도
                        blurRadius: 3, // 그림자 흐림 정도
                        offset: Offset(3, 5), // 그림자의 위치 (가로, 세로)
                      ),
                    ],                    
                  ),
                  child:
                    Image.network(imageList[index] ?? '',width: screenWidth*0.6, height: screenHeight*0.2),
                )
              ]
            )
          );
        },
      ),
    );
  }
}