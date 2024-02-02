import 'package:flutter/material.dart';
import 'package:solution/sudent_profile_page/student_profile.dart';

class BehavirManageScreen extends StatefulWidget {
  BehavirManageScreen({super.key, required this.studentDataList});
  List<dynamic> studentDataList;

  @override
  State<BehavirManageScreen> createState() => _BehavirManageScreenState();
}

class _BehavirManageScreenState extends State<BehavirManageScreen> {
  @override
  Widget build(BuildContext context) {
    // 학생 데이터 리스트
    List<dynamic> studentDataList = widget.studentDataList;

    // 학생의 이름과 행동을 저장할 Map 리스트
    List<Widget> behaviorWidgetList = [];

    for (var studentData in studentDataList) {
      if (studentData is Map<String, dynamic>) {
        String name = studentData['name'];
        List<dynamic> behaviors = studentData['behavior'];
        // 각 행동에 대해 Text 위젯을 생성하여 behaviorWidgetList에 추가
        for (var behavior in behaviors) {
          behaviorWidgetList.add(Text("$name, $behavior end"));
        }
      }
    }

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Text(
                    '행동 관리',
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ],
              ),
            ),
            buildBehaviorCard(name: "이르미", behavior: "머리 때리기", type: "횟수")
          ],
        ),
      ),
    );
  }

  Widget buildBehaviorCard({required name, required behavior, required type}) {
    String studentName = name;
    String studnetBehavior = behavior;
    String recordType = type;

    double buttonsSize = 40;

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(top: 10),
        height: 130, //카드들의 높이는 하드코딩으로 정해주는 것이 가로/세로에 이득이다.
        width: MediaQuery.of(context).size.width - 10,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(color: Colors.grey)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Container(
                height: 90,
                width: 90,
                color: Colors.amber,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    studnetBehavior,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.parent,
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  size: buttonsSize,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu, size: buttonsSize),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
