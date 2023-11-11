import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ssok/widgets/pockets/all_registered_pocket.dart';
import 'package:ssok/widgets/pockets/not_registered_pocket.dart';
import 'package:ssok/widgets/pockets/registered_pocket.dart';
import 'package:ssok/http/http.dart';
import 'package:ssok/http/token_manager.dart';

class PocketPage extends StatefulWidget {
  const PocketPage({super.key});

  @override
  State<PocketPage> createState() => _PocketPageState();
}

class _PocketPageState extends State<PocketPage> {
  ApiService apiService = ApiService();
  String? uuid;
  int? seq;
  String? accountNum;
  int? pocketMoney;
  int? pocketTotalDonate;
  int? pocketTotalPoint;


  @override
  void initState() {
    super.initState();
    getUuid();
  }
void getUuid()async{
    final response = await apiService.getRequest('member-service/temp?refresh-token=${TokenManager().refreshToken}', TokenManager().accessToken);
    print("uuid가져옴");
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        uuid = jsonData['response'];
      });
      getSeq();
    } else {
      throw Exception('Failed to load');
    }
}

void getSeq()async{
    final response = await apiService.getRequest('member-service/member/seq?member-uuid=${uuid}', TokenManager().accessToken);
    print("seq가져옴");
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        seq = jsonData['response'];
      });
      getAccountStatus();
    } else {
      throw Exception('Failed to load');
    }
}

void getAccountStatus()async{
    final response = await apiService.getRequest('member-service/member/account?member-seq=${seq}', TokenManager().accessToken);
    print("계좌가져옴");
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        accountNum = jsonData['response'];
      });
      getPocket();
    } else {
      throw Exception('Failed to load');
    }
}

void getPocket()async{
    final response = await apiService.getRequest('pocket-service/pocket', TokenManager().accessToken);
    print("포켓가져옴");
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      setState(() {
        pocketMoney = jsonData['response']['pocketSaving'];
        pocketTotalDonate = jsonData['response']['pocketTotalDonate'];
        pocketTotalPoint = jsonData['response']['pocketTotalPoint'];
      });
    } else {
      print("에러다 에러");
      print(jsonDecode(utf8.decode(response.bodyBytes))['error']['message']);
      throw Exception('Failed to load');
    }
}

  @override
  Widget build(BuildContext context) {
    // return accountNum==null?NotRegisteredPocket():RegisteredPocket();
    if(accountNum==null){
      return NotRegisteredPocket();
    }else if(pocketMoney==null){
      return RegisteredPocket();
    }else{
      return AllRegisteredPocket(pocketTotalDonate: pocketTotalDonate,
  pocketTotalPoint: pocketTotalPoint,);
    }
  }
}
