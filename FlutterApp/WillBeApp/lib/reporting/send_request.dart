import 'package:http/http.dart' as http;

Future<void> _sendPostRequest(
    String body, String? _responseBody) async {
  // HTTP POST 요청 송신 및 응답 수신 메소드
  try {
    final response = await http.post(
      // HTTP POST 요청 송신 및 응답 수신
      Uri.parse('https://willbe-nlp-t5feuxbhta-du.a.run.appv1/summary/report'), // URL을 파싱
      headers: {"Content-Type": "application/json"}, // 헤더 설정
      body: body, // 요청 본문 설정
    );
    // 상태 변경
    _responseBody = response.body; // 응답 본문 저장
  } catch (e) {
    print(e);
  }
}
