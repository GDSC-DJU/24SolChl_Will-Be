import 'package:http/http.dart' as http;


class PostRequestForm extends StatefulWidget {
  const PostRequestForm({super.key});

  @override
  _PostRequestFormState createState() => _PostRequestFormState();
}

class _PostRequestFormState extends State<PostRequestForm> { // _PostRequestFormState는 PostRequestForm의 상태 표현
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController(text: 'https://...'); // URL을 입력받기 위한 컨트롤러
  final _bodyController = TextEditingController(text: '{\n    "contexts": [\n        "겨울"\n    ]\n}'); // HTTP 요청 본문을 입력받기 위한 컨트롤러
  String? _responseBody; // HTTP 응답 본문을 저장할 변수
  bool _applyFormat = false; // 응답 본문을 서식에 맞게 표시할지 여부 결정하는 플래그
  bool _isLoading = false; // HTTP 요청이 실행 중인지 여부 나타내는 플래그

  Future<void> _sendPostRequest(String url, String body) async { // HTTP POST 요청 송신 및 응답 수신 메소드
    setState(() { // 상태 변경
      _isLoading = true; // 로딩 상태 시작
    });
    try {
      final response = await http.post( // HTTP POST 요청 송신 및 응답 수신
        Uri.parse(url), // URL을 파싱
        headers: {"Content-Type": "application/json"}, // 헤더 설정
        body: body, // 요청 본문 설정
      );
      setState(() { // 상태 변경
        _responseBody = response.body; // 응답 본문 저장
      });
    } catch (e) { // 예외 처리
      showDialog( // 대화 상자 표시
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'), // 대화 상자의 제목 설정
          content: Text('An error occurred: $e'), // 대화 상자의 내용 설정
        ),
      );
    } finally {
      setState(() { // 상태 변경
        _isLoading = false; // 로딩 상태 종료
      });
    }
//...