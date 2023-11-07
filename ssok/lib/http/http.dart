import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  String baseUrl = "https://gateway.ssok.site/api";
  Map<String, String> headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
    'ACCESS-TOKEN':
        "eyJhbGciOiJIUzI1NiJ9.eyJtZW1iZXJVVUlEIjoiYWU4OTUyMDAtYTA1ZC00MTNkLWJmMGQtMDQ5OGFjZjc0MTJjIiwiaWF0IjoxNjk5MzM4ODEyLCJleHAiOjE2OTkzNDI0MTJ9.MzX3OtwwX1OqyEIAm0BBKoRyY8RBncZgRaHaAxprk0Q",
  };

  Future<http.Response> getRequest(String endpoint) async {
    final response =
        await http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);
    return response;
  }

  Future<http.Response> postRequest(
    String endpoint,
    Map<String, String> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return response;
  }
}
