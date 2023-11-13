import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

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

  Future<http.Response> postRawRequest(
      String endpoint, String data, String? accessToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'ACCESS-TOKEN': accessToken ?? ""
      },
      body: data,
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

  Future<dynamic> postRequestWithFile(String endpoint, String? key,
      String? data, String? accessToken, Uint8List bytes) async {
    var uri = '$baseUrl/$endpoint';
    print(uri);
    FormData formData;
    if (key == null) {
      formData = FormData.fromMap({
        'img': await MultipartFile.fromBytes(
          bytes,
          filename: 'mycard.png',
          contentType: MediaType('image', 'png'),
        ),
      });
    } else {
      formData = FormData.fromMap({
        'image': await MultipartFile.fromBytes(
          bytes,
          filename: 'mycard.png',
          contentType: MediaType('image', 'png'),
        ),
        key: data
      });
    }

    Dio dio = Dio();

    dio.options.headers = {'ACCESS-TOKEN': accessToken};
    dio.options.contentType = 'multipart/form-data';

    print(dio.options.contentType);
    var response = await dio.post(
      uri,
      data: formData,
    );
    // var response = await dio.request(uri,
    //     options: Options(
    //       method: 'POST',
    //       headers: headers,
    //     ),
    //     data: data);

    try {
      if (response.statusCode == 200) {
        print(json.encode(response.data));
        return json.encode(response.data);
      } else {
        print(response.statusMessage);
        return response.statusMessage;
      }
    } catch (e) {
      print('업로드 중 에러 발생: $e');
      return http.Response('Error', 500);
    }
  }
}

//   Future<http.Response> postRequestWithFile(String endpoint,
//       Map<String, String> data, String? accessToken, Uint8List bytes) async {
//     print(jsonEncode(data));
//     // print(bytes);
//     var uri = Uri.parse('$baseUrl/$endpoint');
//     var request = http.MultipartRequest('POST', uri);
//     request.headers.addAll({
//       'accept': 'application/json',
//       'ACCESS-TOKEN': accessToken ?? "",
//     });
//     request.fields.addAll(data);
//     // final http.MultipartFile file = http.MultipartFile.fromBytes(
//     //   'image',
//     //   bytes,
//     //   // filename: 'image.png',
//     //   // contentType: MediaType('image', 'png'),
//     // );
//     // print(file.path);
//     request.files.add(await http.MultipartFile.fromBytes(
//       'image', bytes,
//       filename: 'mycard.png',
//       contentType: MediaType.parse('image/png'),
//       // filename: 'mycard.png',
//       // contentType: MediaType('image', 'png'),
//     ));

//     http.StreamedResponse response = await request.send();
//     print(response);
//     try {
//       if (response.statusCode == 200) {
//         print(response.stream.bytesToString());
//         return http.Response.fromStream(response);
//       } else {
//         print('업로드 실패: ${response.statusCode}');
//         // 실패 응답 처리
//         return http.Response('Error', response.statusCode);
//       }
//     } catch (e) {
//       print('업로드 중 에러 발생: $e');
//       return http.Response('Error', 500);
//     }
//   }
// }
