import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ssok/screens/loading/basic_loading_page.dart';
import 'package:ssok/widgets/frequents/show_success_dialog.dart';
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
  bool? pocketIsChangeSaving;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUuid();
  }

  void getUuid() async {
    final response = await apiService.getRequest(
        'member-service/temp?refresh-token=${TokenManager().refreshToken}',
        TokenManager().accessToken);
    print("uuid가져옴");
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        uuid = jsonData['response'];
      });
      getSeq();
    } else if (response.statusCode == 401) {
      // ignore: use_build_context_synchronously
      showSuccessDialog(context, "로그인 세션 만료", "다시 로그인 해주세요", () {
        Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
      });
    }
    {
      throw Exception('Failed to load');
    }
  }

  void getSeq() async {
    final response = await apiService.getRequest(
        'member-service/member/seq?member-uuid=${uuid}',
        TokenManager().accessToken);
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

  void getAccountStatus() async {
    final response = await apiService.getRequest(
        'member-service/member/account?member-seq=${seq}',
        TokenManager().accessToken);
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

  void getPocket() async {
    if (accountNum != null) {
      final response = await apiService.getRequest(
          'pocket-service/pocket', TokenManager().accessToken);
      print("pocket_page getPocket()");
      final jsonData = jsonDecode("${utf8.decode(response.bodyBytes)}");
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      if (response.statusCode == 200) {
        setState(() {
          pocketMoney = jsonData['response']['pocketSaving'];
          pocketTotalDonate = jsonData['response']['pocketTotalDonate'];
          pocketTotalPoint = jsonData['response']['pocketTotalPoint'];
          pocketIsChangeSaving = jsonData['response']['pocketIsChangeSaving'];
          isLoading = false;
        });
      } else if (response.statusCode == 500) {
        setState(() {
          isLoading = false;
        });
      } else {
        print("pocket_page getPocket() 오류 발생");
        print(jsonDecode(utf8.decode(response.bodyBytes))['error']['message']);
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load');
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return accountNum==null?NotRegisteredPocket():RegisteredPocket();
    if (isLoading) {
      return Center(child: BasicLoadingPage());
    } else {
      // 모든 데이터가 로딩된 후에는 해당 화면을 보여줌
      if (accountNum == null) {
        return NotRegisteredPocket();
      } else if (pocketMoney == null) {
        return RegisteredPocket();
      } else {
        return AllRegisteredPocket(
          pocketTotalDonate: pocketTotalDonate,
          pocketTotalPoint: pocketTotalPoint,
          pocketIsChangeSaving: pocketIsChangeSaving,
        );
      }
    }
  }
}
