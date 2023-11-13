import 'package:flutter/material.dart';
import 'package:ssok/widgets/pockets/childrens/my_account.dart';
import 'package:ssok/widgets/pockets/childrens/my_pocket.dart';

class AllRegisteredPocket extends StatefulWidget {
  const AllRegisteredPocket({super.key, this.pocketTotalDonate, this.pocketTotalPoint, this.pocketIsChangeSaving,});
  final int? pocketTotalDonate;
  final int? pocketTotalPoint;
  final bool? pocketIsChangeSaving;

  @override
  State<AllRegisteredPocket> createState() => _AllRegisteredPocketState();
}

class _AllRegisteredPocketState extends State<AllRegisteredPocket> {
int level = 0;
double exp = 0;
String name = "";
bool _isCheckedChanges = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    int pd = widget.pocketTotalDonate ?? 0;
    int pp = widget.pocketTotalPoint ?? 0;
    _isCheckedChanges = widget.pocketIsChangeSaving ?? false;
    int sum = pd+pp;

    if(0<=sum && sum<10000){
      setState(() {
        level = 0;
        exp = (sum)/10000.0;
        name = "LV 1";
      });
    }else if(10000 <= sum && sum <50000){
      print("?");
      setState(() {
        level = 1;
        exp = (sum-10000)/50000.0;
        name = "LV 2";
      });
    }else if(50000 <= sum && sum <300000){
      setState(() {
        level = 2;
        exp = (sum-50000)/300000.0;
        name = "LV 3";
      });      
    }else if(300000 <= sum && sum <1000000){
      setState(() {
        level = 3;
        exp = (sum-300000)/1000000.0;
        name = "LV 4";
      });      
    }else{
      setState(() {
        level = 4;
        exp = 1;
        name = "LV 5";
      });      
    }


  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        // SizedBox(height: screenHeight * 0.03),
        Row(
          mainAxisAlignment:  MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 108,
            ),
            Row(
              children:[
            Text(
              "잔돈 저금하기",
              style: TextStyle(fontSize: 15),
            ),
            Switch(
              value: _isCheckedChanges,
              onChanged: (value) {
                setState(() {
                  
                  _isCheckedChanges = value;
                });
              },
            )]),
          ],
        ),
        MyAccount(),
        SizedBox(height: screenHeight * 0.02),
        MyPocket(
          onTap: () {
            Navigator.of(context).pushNamed('/pocket/history/list');
          },
        ),
        SizedBox(height: screenHeight * 0.03),




        
        Divider(
          height: 1,
          indent: screenWidth * 0.1,
          endIndent: screenWidth * 0.1,
          color: Color(0xFFB2B2B2),
        ),
        SizedBox(height: screenHeight * 0.01),
        Image.asset(
          "assets/level.png",
          height: 80,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(name,style: TextStyle(
    fontSize: 30)),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          "assets/level${level}.png",
          height: 150,
        ),
        SizedBox(height: screenHeight * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
          Text("EXP ",style: TextStyle(
    fontSize: 18)),
          SizedBox(
            width:200,
            child:LinearProgressIndicator(
              value:exp, // 진행 상태를 나타내는 값
              minHeight: 20, // 프로그레스 바의 높이
              backgroundColor: Colors.grey[300], // 배경 색상
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // 진행 바 색상
            )
          ),
          // Icon(
          //   Icons.help_center,
          //   color: Colors.blue,
          // ),
          Text("  "+((exp*100).toInt()).toString() + "%",style: TextStyle(
    fontSize: 18)),
        ]),
      ]
    );
  }
}
