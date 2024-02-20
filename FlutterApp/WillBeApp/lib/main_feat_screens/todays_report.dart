import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:solution/main_feat_screens/chart_builder.dart';

class TodaysReportPage extends StatefulWidget {
  TodaysReportPage({
    super.key,
    required this.names,
    required this.behaviors,
    required this.studentIDs,
  });

  //학생명_행동이름: 학생ID
  List names = [];
  List behaviors = [];
  List studentIDs = [];

  @override
  State<TodaysReportPage> createState() => _TodaysReportPageState();
}

class _TodaysReportPageState extends State<TodaysReportPage> {
  final List<bool> _isSelected = [];
  String? _selectedStdID;
  String? _selectedBehaviorName;
  final _formKey = GlobalKey<FormState>();
  final _situationController = TextEditingController();
  final _actionController = TextEditingController();
  final _etcController = TextEditingController();
  List<Widget> behaviorBtn = <Widget>[];
  User user = FirebaseAuth.instance.currentUser!;
  final List<String> _listedBehaviorIDStudentID = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String selectedBehaviorIDStudentID = '';
  List<String> splitedIDs = [];
  String nowDay = DateTime.now().toString().substring(0, 10);

  String behaviorName = "";

  ChartService chartService = ChartService();
  LineChart? chart;
  Future<void> _loadReportAndChart() async {
    DocumentSnapshot documentSnapshot = await db
        .collection("Record")
        .doc(widget.studentIDs[_isSelected.indexOf(true)])
        .collection("Report")
        .doc(user.uid)
        .collection("Daily")
        .doc(widget.behaviors[_isSelected.indexOf(true)])
        .get();

    try {
      dynamic data =
          documentSnapshot.get(DateTime.now().toString().substring(0, 10));

      if (data != null) {
        print("도큐몬트 가져오기 ${data.toString()}");

        _situationController.text = data['situation'] ?? '';
        _actionController.text = data['action'] ?? '';
        _etcController.text = data['etc'] ?? '';
        setState(() {});
      }
    } catch (e) {
      _situationController.clear();
      _actionController.clear();
      _etcController.clear();
    }

    LineChart chart = await chartService.dayChartData(
        context: context,
        date: DateTime.now(),
        studentID: widget.studentIDs[_isSelected.indexOf(true)],
        behavior: widget.behaviors[_isSelected.indexOf(true)]);

    setState(() {
      this.chart = chart;
    });
  }

  Future<void> _saveReport() async {
    if (_formKey.currentState!.validate()) {
      // 입력한 값들을 Firestore에 저장
      String nowDay = DateTime.now().toString().substring(0, 10);

      DocumentSnapshot doc = await db
          .collection("Record")
          .doc(widget.studentIDs[_isSelected.indexOf(true)])
          .collection("Report")
          .doc(user.uid)
          .collection("Daily")
          .doc(widget.behaviors[_isSelected.indexOf(true)])
          .get();
      doc.reference.update({
        nowDay: {
          'situation': _situationController.text,
          'action': _actionController.text,
          'etc': _etcController.text,
        }
      });

      // 사용자에게 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데일리 노트 작성 완료!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.names.length; i++) {
      String stdName = widget.names[i];
      String behavName = widget.behaviors[i];
      String stdID = widget.studentIDs[i].toString();

      // _listedBehaviorIDStudentID)")
      // _listedBehaviorIDStudentID
      behaviorBtn.add(
        Text(
          key: Key("${stdID}_$behavName"), // 텍스트의 키  = "행동ID/학생ID"
          '$stdName \n $behavName',
          style: const TextStyle(
              fontWeight: FontWeight.w400, color: Color.fromARGB(255, 0, 0, 0)),
        ),
      );

      _isSelected.add(false);
    }

    _isSelected[0] = true;

    print("lenghtof _isSelected : ${_isSelected.length}");

    _loadReportAndChart();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '오늘 기록하기',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          surfaceTintColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ToggleButtons(
                          isSelected: _isSelected,
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < _isSelected.length; i++) {
                                _isSelected[i] = i == index;
                              }
                              print('_iselected : $_isSelected');
                              _loadReportAndChart();
                            });
                          },
                          selectedColor: Colors.white,
                          fillColor: const Color.fromARGB(136, 205, 205, 205),
                          color: Colors.red[400],
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 135.0,
                          ),
                          children: behaviorBtn,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width - 40,
                              child: chart),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "데일리 노트",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "선행사건(필수)",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "행동이 발생할 때 전반적인 상황 \n예시) 화장실이 급할 때 행동이 나타난다",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        child: TextFormField(
                          controller: _situationController,

                          decoration: InputDecoration(
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          autofillHints: const [AutofillHints.givenName],
                          minLines: 5, // this will,
                          maxLines: null, // 줄 수에 제한이 없습니다.

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '선행 사건은 필수로 입력해야 합니다.';
                            }
                            return null;
                          },
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "후속결과(필수)",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "행동이 발생한 후 뒤에 따라온 결과 \n예시) 화장실이 급할 때 행동이 나타난다",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          controller: _actionController,

                          maxLines: null, // 줄 수에 제한이 없습니다.
                          autofillHints: const [AutofillHints.givenName],
                          minLines: 5, // this will,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' 후속결과는 필수로 입력해야 합니다.';
                            }
                            return null;
                          },
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        "특이사항(선택)",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          controller: _etcController,

                          maxLines: null, // 줄 수에 제한이 없습니다.
                          autofillHints: const [AutofillHints.givenName],
                          minLines: 5, // this will,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: const MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () {
                    _saveReport();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "저장하기",
                        style: TextStyle(
                          fontSize: 27,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
