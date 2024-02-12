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
  final _authentication = FirebaseAuth.instance;

  ///행동 카드들의 순서를 내부 저장소에서 가져오는 메서드
  ///메서드 흐름: 순서정보가 없을 때는 1부터 정상적으로 저장하고, 있다면 정수 리스트로 반환
  final db = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;

  List<String>? sortedBehaviors = [];
  List<String> valuesList = [];
  Future<Widget>? cards;

  ///행동카드 순번대로 정렬하는 함수
  ///Firestore의 계정에서 카드들의 순번을 받아와서 정렬 후 행동UUID를 순번대로 정렬 후 List형태로 출력
  Future<List<String>?> getSortedBehaviors() async {
    QuerySnapshot? snapshotOrder;
    Map<String, dynamic>? behaviors;

    int lengthOfBehaviors = 0;

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
    getSortedBehaviors().then((value) {
      setState(() {
        sortedBehaviors = value;
        cards = buildBehaviorCards(behaviorList: sortedBehaviors);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 학생 데이터 리스트
    List<dynamic> studentDataList = widget.studentDataList;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
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
                  onPressed: () {},
                  icon: const Icon(Icons.expand_more_sharp),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.sizeOf(context).width,
              color: Colors.blue,
              child: const Column(
                children: [Row()],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.amber,
              ),
            )
          ],
        ),
      ),
    );
  }

  ///학생의 이름, 행동, 행동유형을 기반으로 행동 카드를 생성해주는 기능
  Future<Widget> buildBehaviorCards(
      {required List<String>? behaviorList}) async {
    QuerySnapshot? snapshotStudents;
    DocumentSnapshot? snapshotTemp;

    try {
      snapshotStudents = await db
          .collection('Educator')
          .doc(user.uid)
          .collection('student')
          .get();
    } catch (e) {
      print("fetchdata error------------------------------------");
    }
    print("소유한 학생 아이디들 출력");

    for (var behavior in behaviorList!) {
      for (var student in snapshotStudents!.docs) {
        try {
          snapshotTemp = await db
              .collection('Student')
              .doc(student.id)
              .collection('Behaviors')
              .doc(behavior)
              .get();
        } catch (e) {}
        if (snapshotTemp!.exists) {
          print('${student.id}의 행동:  $behavior 이름: ${snapshotTemp.get("행동명")}');
        }
      }
    }

    for (var doc in snapshotStudents!.docs) {
      print(doc.id);
    }

    return Container();
  }
}
