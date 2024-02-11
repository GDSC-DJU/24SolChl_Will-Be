///이 파일은 행동관리를 위한 화면으로 계정이 속한 학교/학급의 아동들의
///행동들을 넘겨받아 화면에 보여줌.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solution/main_feat_screens/behavior_add_screen.dart';
import 'package:solution/main_feat_screens/behavior_edit_screen.dart';
import 'package:solution/student_profile_page/student_profile.dart';
import 'package:intl/intl.dart';

class BehavirRecordScreen extends StatefulWidget {
  BehavirRecordScreen({super.key, required this.studentDataList});
  List<dynamic> studentDataList;

  @override
  State<BehavirRecordScreen> createState() => _BehavirRecordScreenState();
}

class _BehavirRecordScreenState extends State<BehavirRecordScreen> {
  // 학생의 이름과 행동을 저장할 Map 리스트
  List<Widget> behaviorWidgetList = [];
  final _authentication = FirebaseAuth.instance;

  ///행동 카드들의 순서를 내부 저장소에서 가져오는 메서드
  ///메서드 흐름: 순서정보가 없을 때는 1부터 정상적으로 저장하고, 있다면 정수 리스트로 반환
  final db = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;
  List<String>? studnetList;

  ///Firestore의 계정에서 카드들의 순번을 받아와서 정렬 후 행동UUID를 순번대로 정렬 후 List형태로 출력
  Future<List<String>?> getSortedBehaviors() async {
    QuerySnapshot? snapshotOrder;
    Map<String, dynamic>? behaviors;

    int lengthOfBehaviors = 0;
    List<String> valuesList = [];

    String studentUID;
    studentUID = user.uid;
    try {
      snapshotOrder = await db
          .collection('Educator')
          .doc(studentUID)
          .collection('order')
          .get();
    } catch (e) {
      print("fetchdata error------------------------------------");
    }

    for (var doc in snapshotOrder!.docs) {
      behaviors = doc.data() as Map<String, dynamic>?;
      behaviors?.forEach((key, value) {
        lengthOfBehaviors++;
        print('Behavior name: $key, Value: $value');
      });
    }

    for (int i = 0; i <= lengthOfBehaviors; i++) {
      behaviors!.forEach((key, value) {
        if (value == i.toString()) {
          valuesList.add(key);
        }
      });
    }

    for (var element in valuesList) {
      print('정렬 후 출력 $element');
    }
    return valuesList;
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy년 MM월 dd일').format(now);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSortedBehaviors();
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
        }
      }
    }
    print(behaviorWidgetList.toString());
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '행동 기록',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  getCurrentDate(),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.expand_more_sharp))
              ],
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
      height: 130, //카드들의 높이는 하드코딩으로 정해주는 것이 가로/세로에 이득이다.
      width: MediaQuery.of(context).size.width - 100,
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
                  width: 100,
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
      ]),
    );
  }
}
