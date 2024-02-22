import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiCommunication {
  ApiCommunication({
    required this.url,
    required this.inputBody,
  }) {
    _inputJson = jsonEncode(inputBody);
    _sendPostRequest();
  }

  final String url;
  final Future<List<dynamic>> inputBody;
  late final String _inputJson;  // JSON format body
  String? _responseJson;

  Future<void> _sendPostRequest() async {
    // HTTP POST 요청 송신 및 응답 수신 메소드
    try {
      final response = await http.post(
        // HTTP POST 요청 송신 및 응답 수신
        Uri.parse(url), // URL을 파싱
        headers: {"Content-Type": "application/json"}, // 헤더 설정
        body: _inputJson, // 요청 본문 설정
      );
      _responseJson = response.body; // 응답 본문 저장
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> getRespond () async {
    await _sendPostRequest();
    return _responseJson!;
  }
}
