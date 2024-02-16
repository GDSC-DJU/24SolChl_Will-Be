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

  Stream<List<Widget>> historyToday({
    required BuildContext context,
  }) {
    StreamController<List<Widget>> controller = StreamController<
        List<Widget>>.broadcast(); // BroadcastStreamController로 초기화

    Map<String, String> mapTimeName = {};

    Stream<List<DocumentSnapshot>> fetchRecords() {
      StreamController<List<DocumentSnapshot>> controller = StreamController();
      String nowDay = DateTime.now().toString().substring(0, 10);

      Stream<QuerySnapshot> snapshotStudents = db
          .collection('Educator')
          .doc(user.uid)
          .collection('Student')
          .snapshots();

      snapshotStudents.listen((snapshot) async {
        List<DocumentSnapshot> records = [];

        for (var doc in snapshot.docs) {
          DocumentSnapshot docSnapshot = await db
              .collection('Student')
              .doc(doc.id)
              .collection('BehaviorRecord')
              .doc(nowDay) //예) 2024-02-14
              .get();

          Map<String, dynamic> fields =
              docSnapshot.data() as Map<String, dynamic>;
          DocumentSnapshot stdCollection =
              await docSnapshot.reference.parent.parent!.get();

          if (docSnapshot.exists) {
            fields.forEach((key, value) {
              mapTimeName[key] = stdCollection.get('name');
            });

            records.add(docSnapshot);
          }
        }

        controller.add(records);
      });

      return controller.stream;
    }

    Stream<List<DocumentSnapshot>> recordsStream = fetchRecords();

    recordsStream.listen((records) {
      List<Record> allRecords = []; // 모든 행동의 기록을 저장할 리스트

      for (var record in records) {
        Map<String, dynamic> data = record.data() as Map<String, dynamic>;
        data.forEach((key, value) {
          Map<String, dynamic> behaviorData = value as Map<String, dynamic>;
          behaviorData.forEach((behaviorKey, behaviorValue) {
            allRecords.add(Record(
                time: key,
                behaviorKey: behaviorKey,
                behaviorValue: behaviorValue));
          });
        });
      }

      // 모든 행동의 기록을 시간 순으로 정렬
      allRecords.sort(
          (a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));

      List<Widget> recordList = [];
      for (var record in allRecords) {
        print("record ${record.time}");
        print("behaviorKey ${record.behaviorKey}");
        print("behaviorValue ${record.behaviorValue}");

        recordList.add(
          ListTile(
            minVerticalPadding: 0,
            selectedTileColor: Colors.blue,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mapTimeName[record.time]!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  record.behaviorValue,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  record.time.substring(10, 19),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            onTap: () {
              print(record.behaviorValue);
            },
          ),
        );
      }

      controller.add(recordList); // controller에 데이터 추가
      print("길이 확인 ${recordList.length}");
    });

    controller.stream.listen((list) {
      // 스트림의 데이터를 처리하고 출력
      print('길이 확인: ${list.length}');
    });

    return controller.stream; // controller의 스트림을 반환
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
            StreamBuilder<List<Widget>>(
              stream: historyToday(context: context),
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
            Expanded(child: widget.cards!)
          ],
        ),
      ),
    );
  }
}

class Record {
  final String time;
  final String behaviorKey;
  final String behaviorValue;

  Record(
      {required this.time,
      required this.behaviorKey,
      required this.behaviorValue});
}
