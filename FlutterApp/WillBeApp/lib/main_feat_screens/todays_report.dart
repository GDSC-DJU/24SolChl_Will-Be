import 'package:flutter/material.dart';

class TodaysReportPage extends StatefulWidget {
  TodaysReportPage({
    super.key,
    required this.studentDataList,
    required this.behaviorIDAndStudentID,
    required this.studentList,
    required this.mapForBehaviorsData,
  });

  Map<String?, String?> behaviorIDAndStudentID = {};
  List studentList = [];
  List<dynamic> studentDataList;
  Map<String, Map<String, String>> mapForBehaviorsData = {};

  List<Widget> behaviorBtn = <Widget>[];

  @override
  State<TodaysReportPage> createState() => _TodaysReportPageState();
}

class _TodaysReportPageState extends State<TodaysReportPage> {
  final List<bool> _isSelected = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.mapForBehaviorsData.forEach((key, value) {
      value.forEach((behavName, stdName) {
        widget.behaviorBtn.add(
          Text(
            key: Key(key.toString()),
            '$stdName \n $behavName',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
        );
        _isSelected.add(false);
      });
    });
    _isSelected[0] = true;

    for (var element in widget.behaviorBtn) {
      element.key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오늘 기록하기',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
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
                      });
                    },
                    selectedColor: Colors.white,
                    fillColor: const Color.fromARGB(136, 205, 205, 205),
                    color: Colors.red[400],
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 135.0,
                    ),
                    children: widget.behaviorBtn,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width - 40,
                      color: const Color.fromARGB(255, 169, 200, 206),
                    )
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
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
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
                    maxLines: null, // 줄 수에 제한이 없습니다.

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
                Container(
                  color: const Color.fromARGB(255, 240, 240, 240),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    maxLines: null, // 줄 수에 제한이 없습니다.

                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
