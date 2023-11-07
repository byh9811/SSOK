import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  String baseUrl = "https://gateway.ssok.site/api";

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
      String endpoint, Map<String, String> data, String? accessToken) async {
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
}
