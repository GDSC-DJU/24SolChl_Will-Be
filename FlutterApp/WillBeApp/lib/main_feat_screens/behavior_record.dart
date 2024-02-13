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

  // 형식 {행동ID : {행동 이름 : 아동 이름} }
  Map<String, Map<String, String>> mapForBehaviorsData = {};

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
            Text(
              "버튼 눌러서 기록하기",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: FutureBuilder<Widget>(
                future: cards,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // 로딩 중일 때 표시할 위젯
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // 오류 발생 시 표시할 위젯
                  } else if (snapshot.hasData) {
                    // 데이터가 있는 경우에만 데이터에 접근
                    return snapshot.data!; // 로딩이 완료되면 data를 표시
                  } else {
                    return const Text(''); // 데이터가 없는 경우 표시할 위젯
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ///학생의 이름, 행동, 행동유형을 기반으로 행동 카드를 생성해주는 기능
  Future<Widget> buildBehaviorCards(
      {required List<String>? behaviorList,
      required Map<String?, String?> behaviorIDAndStudentID}) async {
    ///내 계정에 등록된 아이의 ID를 가져오는 스냅샷
    QuerySnapshot? snapshotStudents;

    DocumentSnapshot? snapshotTempBehavior;
    DocumentSnapshot? snapshotTempStudent;

    //행동ID : 아동ID의 형태로 저장
    Map<String?, String?> behaviorIDAndStudentID = {};

    try {
      //사용자가 가지는 학생들의 데이터 불러옴
      snapshotStudents = await db
          .collection('Educator')
          .doc(user.uid)
          .collection('student')
          .get();
    } catch (e) {
      print("fetchdata error------------------------------------");
    }

    for (var behavior in behaviorList!) {
      //각 행동의 주인인 아동을 찾아 behaviorIDAndStudentID에 [행동ID] : [아동ID]의 형태로 저장하는 반복문
      for (var student in snapshotStudents!.docs) {
        try {
          snapshotTempBehavior = await db
              .collection('Student')
              .doc(student.id)
              .collection('Behaviors')
              .doc(behavior)
              .get();
          snapshotTempStudent =
              await db.collection('Student').doc(student.id).get();
        } catch (e) {}
        if (snapshotTempBehavior!.exists) {
          print(
              '${student.id}의 행동:  $behavior 이름: ${snapshotTempBehavior.get("행동명")}');
          mapForBehaviorsData[behavior] = {
            snapshotTempBehavior.get('행동명'): snapshotTempStudent!.get('name')
          };

          behaviorIDAndStudentID[behavior] = student.id;
          break;
        }
      }
    }
    print("맵으로 출력 해보기");
    behaviorIDAndStudentID.forEach(
      (key, value) {
        print("$key 행동의 주인은 $value");
      },
    );
    //행동의 개수에 따라 다른 화면을 보여주기 위한 swtich 문
    switch (behaviorIDAndStudentID.length) {
      case 0:
        return const Expanded(
          child: Center(
            child: Text("아동 데이터 또는 행동 데이터가 없습니다."),
          ),
        );

      case 1:
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            print(
                'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
            return Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      //first bahavior
                      GestureDetector(
                        onTap: () async {
                          recordBahvior(
                            behaviorID: behaviorList[0],
                            studentID: behaviorIDAndStudentID[behaviorList[0]],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: constraints.maxHeight - 20,
                          width: constraints.maxWidth - 20,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: const Color.fromRGBO(195, 255, 250, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ]),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white60,
                                        ),
                                        child: Center(
                                          child: Text(mapForBehaviorsData[
                                                  behaviorList[0]]!
                                              .values
                                              .first[0]),
                                        ),
                                      ),
                                      Text(
                                        "  ${mapForBehaviorsData[behaviorList[0]]!.values.first}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    mapForBehaviorsData[behaviorList[0]]!
                                        .keys
                                        .first,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      case 2:
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            print(
                'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
            return Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      recordBahvior(
                        behaviorID: behaviorList[0],
                        studentID: behaviorIDAndStudentID[behaviorList[0]],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: constraints.maxHeight / 2 - 20,
                      width: constraints.maxWidth - 20,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: const Color.fromRGBO(195, 255, 250, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 10), // changes position of shadow
                            ),
                          ]),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white60,
                                    ),
                                    child: Center(
                                      child: Text(
                                          mapForBehaviorsData[behaviorList[0]]!
                                              .values
                                              .first[0]),
                                    ),
                                  ),
                                  Text(
                                    "  ${mapForBehaviorsData[behaviorList[0]]!.values.first}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                mapForBehaviorsData[behaviorList[0]]!
                                    .keys
                                    .first,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //두번째 카드
                  GestureDetector(
                    onTap: () async {
                      recordBahvior(
                        behaviorID: behaviorList[1],
                        studentID: behaviorIDAndStudentID[behaviorList[1]],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: constraints.maxHeight / 2 - 20,
                      width: constraints.maxWidth - 20,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: const Color.fromRGBO(195, 255, 250, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 10), // changes position of shadow
                            ),
                          ]),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white60,
                                    ),
                                    child: Center(
                                      child: Text(
                                          mapForBehaviorsData[behaviorList[1]]!
                                              .values
                                              .first[0]),
                                    ),
                                  ),
                                  Text(
                                    "  ${mapForBehaviorsData[behaviorList[1]]!.values.first}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                mapForBehaviorsData[behaviorList[1]]!
                                    .keys
                                    .first,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      case 3:
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            print(
                'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
            return Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      recordBahvior(
                        behaviorID: behaviorList[0],
                        studentID: behaviorIDAndStudentID[behaviorList[0]],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: constraints.maxHeight / 3 - 20,
                      width: constraints.maxWidth - 20,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: const Color.fromRGBO(195, 255, 250, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 10), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white60,
                                    ),
                                    child: Center(
                                      child: Text(
                                          mapForBehaviorsData[behaviorList[0]]!
                                              .values
                                              .first[0]),
                                    ),
                                  ),
                                  Text(
                                    "  ${mapForBehaviorsData[behaviorList[0]]!.values.first}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                mapForBehaviorsData[behaviorList[0]]!
                                    .keys
                                    .first,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //두번째 카드
                  GestureDetector(
                    onTap: () async {
                      recordBahvior(
                        behaviorID: behaviorList[1],
                        studentID: behaviorIDAndStudentID[behaviorList[1]],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: constraints.maxHeight / 3 - 20,
                      width: constraints.maxWidth - 20,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: const Color.fromRGBO(195, 255, 250, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 10), // changes position of shadow
                            ),
                          ]),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white60,
                                    ),
                                    child: Center(
                                      child: Text(
                                          mapForBehaviorsData[behaviorList[1]]!
                                              .values
                                              .first[0]),
                                    ),
                                  ),
                                  Text(
                                    "  ${mapForBehaviorsData[behaviorList[1]]!.values.first}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                mapForBehaviorsData[behaviorList[1]]!
                                    .keys
                                    .first,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //3번째 코드
                  GestureDetector(
                    onTap: () async {
                      recordBahvior(
                        behaviorID: behaviorList[2],
                        studentID: behaviorIDAndStudentID[behaviorList[2]],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: constraints.maxHeight / 3 - 20,
                      width: constraints.maxWidth - 20,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: const Color.fromRGBO(195, 255, 250, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 10), // changes position of shadow
                            ),
                          ]),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white60,
                                    ),
                                    child: Center(
                                      child: Text(
                                          mapForBehaviorsData[behaviorList[2]]!
                                              .values
                                              .first[0]),
                                    ),
                                  ),
                                  Text(
                                    "  ${mapForBehaviorsData[behaviorList[2]]!.values.first}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                mapForBehaviorsData[behaviorList[2]]!
                                    .keys
                                    .first,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

      //행동 4개일 때
      case 4:
        // key를 사용하여 behaviorIDAndStudentID에서 value를 가져옴
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            print(
                'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
            return Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      // 첫번째 카드
                      GestureDetector(
                        onTap: () async {
                          recordBahvior(
                            behaviorID: behaviorList[0],
                            studentID: behaviorIDAndStudentID[behaviorList[0]],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: constraints.maxHeight / 2 - 20,
                          width: constraints.maxWidth / 2 - 20,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: const Color.fromRGBO(195, 255, 250, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ]),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white60,
                                        ),
                                        child: Center(
                                          child: Text(mapForBehaviorsData[
                                                  behaviorList[0]]!
                                              .values
                                              .first[0]),
                                        ),
                                      ),
                                      Text(
                                        "  ${mapForBehaviorsData[behaviorList[0]]!.values.first}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    mapForBehaviorsData[behaviorList[0]]!
                                        .keys
                                        .first,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //두번째 카드
                      GestureDetector(
                        onTap: () async {
                          recordBahvior(
                            behaviorID: behaviorList[1],
                            studentID: behaviorIDAndStudentID[behaviorList[1]],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: constraints.maxHeight / 2 - 20,
                          width: constraints.maxWidth / 2 - 20,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: const Color.fromRGBO(195, 255, 250, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ]),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white60,
                                        ),
                                        child: Center(
                                          child: Text(mapForBehaviorsData[
                                                  behaviorList[1]]!
                                              .values
                                              .first[0]),
                                        ),
                                      ),
                                      Text(
                                        "  ${mapForBehaviorsData[behaviorList[1]]!.values.first}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    mapForBehaviorsData[behaviorList[1]]!
                                        .keys
                                        .first,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      //3번째 행동 카드
                      GestureDetector(
                        onTap: () async {
                          recordBahvior(
                            behaviorID: behaviorList[2],
                            studentID: behaviorIDAndStudentID[behaviorList[2]],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: constraints.maxHeight / 2 - 20,
                          width: constraints.maxWidth / 2 - 20,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: const Color.fromRGBO(195, 255, 250, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ]),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white60,
                                        ),
                                        child: Center(
                                          child: Text(mapForBehaviorsData[
                                                  behaviorList[2]]!
                                              .values
                                              .first[0]),
                                        ),
                                      ),
                                      Text(
                                        "  ${mapForBehaviorsData[behaviorList[2]]!.values.first}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    mapForBehaviorsData[behaviorList[2]]!
                                        .keys
                                        .first,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //4번째
                      GestureDetector(
                        onTap: () async {
                          recordBahvior(
                            behaviorID: behaviorList[3],
                            studentID: behaviorIDAndStudentID[behaviorList[3]],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: constraints.maxHeight / 2 - 20,
                          width: constraints.maxWidth / 2 - 20,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: const Color.fromRGBO(195, 255, 250, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ]),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white60,
                                        ),
                                        child: Center(
                                          child: Text(mapForBehaviorsData[
                                                  behaviorList[3]]!
                                              .values
                                              .first[0]),
                                        ),
                                      ),
                                      Text(
                                        "  ${mapForBehaviorsData[behaviorList[3]]!.values.first}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    mapForBehaviorsData[behaviorList[3]]!
                                        .keys
                                        .first,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
    }

    return Container();
  }

  void recordBahvior({
    required String? behaviorID,
    required String? studentID,
  }) async {
    // 현재 시간을 가져옵니다.
    DateTime now = DateTime.now();
    // 도큐먼트 ID로 사용할 문자열을 생성합니다.
    String documentID = now.toString();

    try {
      await db
          .collection('Student')
          .doc(studentID)
          .collection('BehaviorRecord')
          .doc(documentID)
          .set({
        // 여기에 필드와 값을 추가하면 됩니다.
        '행동명': mapForBehaviorsData[behaviorID]!.keys.first,
      });
      print('Document successfully added with ID: $documentID');
    } catch (e) {
      print('Failed to add document: $e');
    }
  }
}
