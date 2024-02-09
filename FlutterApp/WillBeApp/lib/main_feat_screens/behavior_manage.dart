///이 파일은 행동관리를 위한 화면으로 계정이 속한 학교/학급의 아동들의
///행동들을 넘겨받아 화면에 보여줌.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solution/main_feat_screens/behavior_add_screen.dart';
import 'package:solution/main_feat_screens/behavior_edit_screen.dart';
import 'package:solution/sudent_profile_page/student_profile.dart';

class BehavirManageScreen extends StatefulWidget {
  BehavirManageScreen({super.key, required this.studentDataList});
  List<dynamic> studentDataList;

  @override
  State<BehavirManageScreen> createState() => _BehavirManageScreenState();
}

class _BehavirManageScreenState extends State<BehavirManageScreen> {
  // 학생의 이름과 행동을 저장할 Map 리스트
  List<Widget> behaviorWidgetList = [];

  ///행동 카드들의 순서를 내부 저장소에서 가져오는 메서드
  ///메서드 흐름: 순서정보가 없을 때는 1부터 정상적으로 저장하고, 있다면 정수 리스트로 반환
  Future<List<int>> getCardSequenceNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sequenceStrList = prefs.getStringList("cardSequence");
    if (sequenceStrList == null) {
      // 순서 정보가 없을 때는 1부터 순서대로 반환
      return List<int>.generate(behaviorWidgetList.length, (i) => i + 1);
    } else {
      // 순서 정보가 있을 때는 이를 정수 리스트로 변환하여 반환
      return sequenceStrList.map((s) => int.parse(s)).toList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCardSequenceNumber().then((sequence) {
      print('순서 번호: $sequence');
    });
  }

  @override
  Widget build(BuildContext context) {
    // 학생 데이터 리스트
    List<dynamic> studentDataList = widget.studentDataList;

    for (var studentData in studentDataList) {
      if (studentData is Map<String, dynamic>) {
        String name = studentData['name'];
        List<dynamic> behaviors = studentData['behavior'];
        // 각 행동에 대해 Text 위젯을 생성하여 behaviorWidgetList에 추가
        for (var behavior in behaviors) {
          behaviorWidgetList.add(buildBehaviorCard(
              //여기서 키값을 index처럼 0~n 번까지의 숫자로 넘겨줘야 하나?
              name: name,
              behavior: behavior.toString(),
              type: "횟수")); //현재 행동 유형은 횟수로 통일 됨 추후 개선 요망
          print("여기서 키값을 프린트 함.");
          print('name: $name, behavior: $behavior, key: $name$behavior');
        }
      }
    }
    print(behaviorWidgetList.toString());
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '행동 관리',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BehaviorAddScreen(
                              studentDataList: studentDataList,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: behaviorWidgetList,
              ),
            ),
          )
        ],
      ),
    );
  }

  ///학생의 이름, 행동, 행동유형을 기반으로 행동 카드를 생성해주는 기능
  Widget buildBehaviorCard(
      {Key? key,
      required String name,
      required String behavior,
      required String type}) {
    double buttonsSize = 35;
    if (behavior.isEmpty || name.isEmpty || type.isEmpty) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 10),
      height: 130, //카드들의 높이는 하드코딩으로 정해주는 것이 가로/세로에 이득이다.
      width: MediaQuery.of(context).size.width - 10,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(color: Colors.grey)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            //행동관리의 아동 사진 추후 업데이트 필요!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            ClipOval(
              child: Image.network(
                "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            ),
            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            const SizedBox(
              //사진과 텍스트간 공백
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - buttonsSize - 230,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft,
                    child: Text(
                      behavior,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Row(
                  children: [
                    Text(
                      "측정 단위 :",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      type,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
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
    );
  }
}
