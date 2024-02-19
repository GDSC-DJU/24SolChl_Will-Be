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
  BehavirRecordScreen({
    super.key,
    required this.cards,
    required this.names,
    required this.behaviors,
    required this.studentIDs,
  });

  Widget? cards;

  //학생명_행동이름: 학생ID
  List names = [];

  List behaviors = [];
  List studentIDs = [];

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
    required List studentIdList,
    required List studentNameList,
    required List behaviorNameList,
  }) {
    StreamController<List<Widget>> controller =
        StreamController<List<Widget>>();
    List<Map<String, dynamic>> allRecords = [];

    for (int i = 0; i < studentIdList.length; i++) {
      String studentId = studentIdList[i];
      String studentName = studentNameList[i];
      String behaviorName = behaviorNameList[i];

      db
          .collection("Record")
          .doc(studentId)
          .collection('Behavior')
          .doc(behaviorName)
          .collection('BehaviorRecord')
          .snapshots()
          .listen((snapshot) {
        for (var element in snapshot.docs) {
          DateTime time = DateTime.parse(element.id);

          if (time.day == DateTime.now().day &&
              time.month == DateTime.now().month &&
              time.year == DateTime.now().year)
            allRecords.add({
              'name': studentName,
              'behavior': behaviorName,
              'time': time,
              'studentId': studentId,
            });
        }

        allRecords.sort((a, b) => b['time'].compareTo(a['time']));

        List<Widget> tiles = allRecords.map((record) {
          String formattedTime =
              "${record['time'].hour.toString().padLeft(2, '0')}:${record['time'].minute.toString().padLeft(2, '0')}:${record['time'].second.toString().padLeft(2, '0')}";

          return ListTile(
            key: Key(record['time'].toString()),
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    record['name'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    record['behavior'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    formattedTime,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () async {
                        print(
                            'record["time"] = [${record['time'].toString()}]');
                        print('record["name"] = ${record['name']}');
                        print('record["behavior"] = ${record['behavior']}');
                        //print studentID and behaviorName
                        print('studentId = $studentId');
                        print('behaviorName = $behaviorName');
                        await db
                            .collection("Record")
                            .doc(record['studentId'])
                            .collection('Behavior')
                            .doc(record['behavior'])
                            .collection('BehaviorRecord')
                            .doc(record['time'].toString())
                            .delete();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList();

        controller.add(tiles);
      });
    }

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
                            studentIDs: widget.studentIDs,
                            behaviors: widget.behaviors,
                            names: widget.names,
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(128, 158, 158, 158), width: 2),
                ),
              ),
              child: const Row(children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "이름",
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "행동명",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "시간",
                  ),
                ),
                Expanded(
                  child: Text(
                    "취소",
                  ),
                ),
              ]),
            ),
            StreamBuilder<List<Widget>>(
              stream: fetchAndSortRecords(
                  context: context,
                  studentIdList: widget.studentIDs,
                  behaviorNameList: widget.behaviors,
                  studentNameList: widget.names),
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
            Expanded(
              child: Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.54,
                    child: widget.cards ?? const SizedBox()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
