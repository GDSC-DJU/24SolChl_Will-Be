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
  BehavirRecordScreen(
      {super.key,
      required this.studentDataList,
      required this.cards,
      required this.behaviorIDAndStudentID,
      required this.mapForBehaviorsData,
      required this.studentList,
      required this.historyToday});
  List<dynamic> studentDataList;
  Widget? cards;
  List<Widget> historyToday;

  Map<String?, String?> behaviorIDAndStudentID = {};
  List studentList = [];

  Map<String, Map<String, String>> mapForBehaviorsData = {};

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

  // 형식 {행동ID : {행동 이름 : 아동 이름} }

  ///행동카드 순번대로 정렬하는 함수
  ///Firestore의 계정에서 카드들의 순번을 받아와서 정렬 후 행동UUID를 순번대로 정렬 후 List형태로 출력

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy년 MM월 dd일').format(now);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.cards.toString());
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
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(128, 158, 158, 158), width: 2),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("이름"), Text("행동명"), Text("시간")],
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.sizeOf(context).width,
                child: ListView(
                  padding: const EdgeInsets.only(top: 0),
                  children: widget.historyToday,
                )),
            Text(
              "버튼 눌러서 기록하기",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(child: widget.cards!)
          ],
        ),
      ),
    );
  }
}
