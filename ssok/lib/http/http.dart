import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  String baseUrl = "https://gateway.ssok.site/api";
  String virtualUrl = "https://k9c107.p.ssafy.io";
  
  Future<http.Response> getRequest(String endpoint, String? accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'ACCESS-TOKEN': accessToken ?? ""
      },
    );
    return response;
  }

  Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> data, String? accessToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'ACCESS-TOKEN': accessToken ?? ""
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> postRequestToVirtual(
      String endpoint, Map<String, dynamic> data, String? accessToken) async {
    final response = await http.post(
      Uri.parse('$virtualUrl/$endpoint'),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'ACCESS-TOKEN': accessToken ?? ""
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> postRequestWithFile(
      String endpoint, String dataKey, Map<String, dynamic> data, String? accessToken, Uint8List bytes) async {

    print(jsonEncode(data));
    final http.MultipartFile file = http.MultipartFile.fromBytes('image', bytes);
    var uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'accept': 'application/json',
      'ACCESS-TOKEN': accessToken ?? ""
    });
    request.fields[dataKey] = jsonEncode(data);
    request.files.add(file);

    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        print('업로드 성공');
        return http.Response.fromStream(streamedResponse);
      } else {
        print('업로드 실패: ${streamedResponse.statusCode}');
        // 실패 응답 처리
        return http.Response('Error', streamedResponse.statusCode);
      }
    } catch (e) {
      print('업로드 중 에러 발생: $e');
      return http.Response('Error', 500);
    }
  }
}
