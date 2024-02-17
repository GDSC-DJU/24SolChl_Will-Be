///이 파일은 행동관리를 위한 화면으로 계정이 속한 학교/학급의 아동들의
///행동들을 넘겨받아 화면에 보여줌.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solution/main_feat_screens/behavior_add_screen.dart';
import 'package:solution/main_feat_screens/behavior_edit_screen.dart';
import 'package:solution/main_feat_screens/todays_report.dart';
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
  Stream<List<Widget>> historyToday;

  Map<String?, String?> behaviorIDAndStudentID = {};
  List studentList = [];

  Map<String, Map<String, String>> mapForBehaviorsData = {};

  @override
  State<BehavirRecordScreen> createState() => _BehavirRecordScreenState();
}

class _BehavirRecordScreenState extends State<BehavirRecordScreen> {
  // 학생의 이름과 행동을 저장할 Map 리스트
  final _authentication = FirebaseAuth.instance;

  final db = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;

  List<String>? sortedBehaviors = [];
  List<String> valuesList = [];

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy년 MM월 dd일').format(now);
  }

  Stream<List<Widget>> fetchAndSortRecords({
    required BuildContext context,
    required String educatorId,
  }) {
    StreamController<List<Widget>> controller =
        StreamController<List<Widget>>();

    String nowDay = DateTime.now().toString().substring(0, 10); // 오늘 날짜

    Stream<QuerySnapshot> snapshotStudents = db
        .collection('Educator')
        .doc(educatorId)
        .collection('Student')
        .snapshots();

    snapshotStudents.listen((snapshot) async {
      List<Map<String, dynamic>> allRecords = [];

      for (var doc in snapshot.docs) {
        db
            .collection("Record")
            .doc(doc.id)
            .collection('Behavior')
            .snapshots()
            .listen((snapshotBH) {
          for (var behaviorDoc in snapshotBH.docs) {
            String behaviorName = behaviorDoc.id;
            behaviorDoc.reference
                .collection('BehaviorRecord')
                .snapshots() // Details 컬렉션의 스냅샷을 구독합니다.
                .listen((recordSnapshot) {
              // 스냅샷이 변경될 때마다 코드 블록이 실행됩니다.
              for (var element in recordSnapshot.docs) {
                DateTime time = DateTime.parse(element.id);

                allRecords.add({
                  'name': behaviorDoc.get('name'),
                  'behavior': behaviorName,
                  'time': time,
                });

                // 시간 내림차순으로 정렬
                allRecords.sort((a, b) => b['time'].compareTo(a['time']));

                // 정렬된 결과를 바탕으로 ListTile 생성
                List<Widget> tiles = allRecords.map((record) {
                  String formattedTime =
                      "${record['time'].hour.toString().padLeft(2, '0')}:${record['time'].minute.toString().padLeft(2, '0')}:${record['time'].second.toString().padLeft(2, '0')}";

                  return ListTile(
                    key: Key(
                        record['time'].toString()), // 각 ListTile에 고유한 Key를 할당

                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          record['name'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          record['behavior'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          formattedTime,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () async {
                            await db
                                .collection("Record")
                                .doc(doc.id)
                                .collection('Behavior')
                                .doc(behaviorName)
                                .collection('BehaviorRecord')
                                .doc(element.id)
                                .delete();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                }).toList();

                controller.add(tiles);
              }
            });
          }
        });
      }
    });

    return controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    // 학생 데이터 리스트

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '행동 기록',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodaysReportPage(
                            studentDataList: widget.studentDataList,
                            behaviorIDAndStudentID:
                                widget.behaviorIDAndStudentID,
                            studentList: widget.studentList,
                            mapForBehaviorsData: widget.mapForBehaviorsData,
                          ),
                        ),
                      );
                    },
                    child: const Text("오늘의 기록하기"),
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
            StreamBuilder<List<Widget>>(
              stream:
                  fetchAndSortRecords(context: context, educatorId: user.uid),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          height: 120,
                          child: Center(child: RefreshProgressIndicator())));
                } else if (snapshot.hasError) {
                  return const Text('Error occurred');
                } else if (snapshot.hasData) {
                  return SizedBox(
                    height: 120,
                    child: ListView(
                      padding: const EdgeInsets.only(top: 0),
                      children: snapshot.data!, // 수정된 부분
                    ),
                  );
                } else {
                  return const Text('No data');
                }
              },
            ),
            Text(
              "버튼 눌러서 기록하기",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(child: widget.cards ?? const SizedBox())
          ],
        ),
      ),
    );
  }
}
