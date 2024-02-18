///이 파일은 사용자가 로그인 후 최초 보여지는 화면입니다.
///로그아웃 버튼을 클릭 시 자동로그인이 풀리며 사용자의 계정 정보는 앱에서 지워지게 됩니다.
///따라서 다시 로그인을 해야합니다.
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solution/login_screens/primary_login_screen.dart';
import 'package:solution/main_feat_screens/behavior_record.dart';
import 'package:solution/main_feat_screens/calendar_manage_screen.dart';
import 'package:solution/main_feat_screens/dashboard_screen.dart';
import 'package:solution/main_feat_screens/home_screen.dart';
import 'package:solution/student_profile_page/student_profile.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({super.key});

  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
  ///Instance for firebase auth
  final _authentication = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  //내부 저장소 사용을 위한 SharedPreferences 객체

  ///정렬될, 정렬에 사용될 리스트들
  List<Map> stdNamebhvNameTostdID = [];
  int numOfCards = 0;
  List names = [];
  List LastNames = [];
  List behaviors = [];
  List studentIDs = [];
  //여기까지

  List<String> valuesList = [];
  List<String>? sortedBehaviors = [];
  Widget? cards;
  Map<String?, String?> behaviorIDAndStudentID = {}; //행동ID : 아동ID의 형태로 저장
  List<Widget> widgetOptions = [];
  Map<String, Map<String, String>> mapForBehaviorsData =
      {}; //행동ID : <행동이름 : 아동이름> 의 형태로 저장

  Stream<List<Widget>> historyWidgetList = const Stream.empty();

  ///하단 네비게이션 바를 위한 인데스
  int _selected_screen = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  User user = FirebaseAuth.instance.currentUser!;

  void _onItemTapped(int index) {
    setState(() {
      _selected_screen = index;
    });
  }

  static const bottomBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: '아이들',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month),
      label: '일정관리',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit_document),
      label: '행동기록',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.pie_chart),
      label: '요약',
    ),
  ];

  ///User instance for logged in user
  //UID of logged in user
  String? uid;
  //Data of logged in user
  Object? userData = {};
  List studentList = [];
  List studentDataList = [];
  List itemContentList = [];

  //Function for sign out
  Future<void> signOut() async {
    try {
      await _authentication.signOut(); // Here
      _authentication.currentUser!.delete;
      print('sign out complete');
    } catch (e) {
      print('sign out failed');
      print(e.toString());
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PrimaryLoginScreen(),
      ),
    );
  }

  // Function : 로그인 성공 시 현재 접속중인 교사 data 가져오기
  Future<void> getEducator(String? userUid) async {
    // 현재 접속 UID를 document로 갖는 객체를 Educator collection에서 가져오기 & Student collection 가져오기
    CollectionReference educatorCollectionRef = FirebaseFirestore.instance
        .collection('Educator')
        .doc(uid)
        .collection('Student');

    // 찾은 객체의 학생 리스트 get (문서 id)
    await educatorCollectionRef.get().then(
      (documentSnapshot) {
        // 리스트로 변환x4Dgi3VK0IWk8C1YPKObjjZfiHL
        studentList = documentSnapshot.docs.map((doc) => doc.id).toList();
        // 디버깅 print
        print("HELELO");
        print(studentList);
        // 학생 데이터 추출 함수 호출
      },
      onError: (e) => print("Error completing: $e"),
    );
    await Future.wait(
        [getStudentData(studentList), getBehaviorList(studentList)]);
  }

  Future<void> getBehavior(String? userUid) async {
    // 현재 접속 UID를 document로 갖는 객체를 Educator collection에서 가져오기 & Student collection 가져오기
    CollectionReference educatorCollectionRef = FirebaseFirestore.instance
        .collection('Educator')
        .doc(uid)
        .collection('Student');

    // 찾은 객체의 학생 리스트 get (문서 id)
    await educatorCollectionRef.get().then(
      (documentSnapshot) {
        // 리스트로 변환x4Dgi3VK0IWk8C1YPKObjjZfiHL
        studentList = documentSnapshot.docs.map((doc) => doc.id).toList();
        // 디버깅 print
        print("HELELO");
        print(studentList);
        // 학생 데이터 추출 함수 호출
      },
      onError: (e) => print("Error completing: $e"),
    );
    await Future.wait([getStudentData(studentList)]);
    print("studentList : $studentList");
  }

  // Function : 교사 데이터 접근 완료 시 학교 DB에서 학생 ID 가져오기
  // Future<void> getStudentList(String school, String classNum) async {
  //   await db.collection("School").doc(school).collection(classNum).get().then(
  //     (querySnapshot) {
  //       print("Successfully completed");
  //       studentList = querySnapshot.docs.map((doc) => doc.id).toList();
  //       print(studentList);
  //       getStudentData(studentList);
  //     },
  //     onError: (e) => print("Error completing: $e"),
  //   );
  // }

  bool isLoading = true;

  // Function : 학생List -> 학생 데이터 추출 함수
  Future<void> getStudentData(List studentList) async {
    if (!isLoading) {
      return; // 이미 데이터 로딩이 완료된 경우 중복 호출 방지
    }

    print(studentList);
    print("Hell222o");
    studentDataList = [];
    for (var student in studentList) {
      await db.collection("Student").doc(student).get().then((querySnapshot) {
        final temp = querySnapshot.data();
        studentDataList.add(temp);
      });
    }
    print("Hello");
    print("studentDataList : $studentDataList");
    isLoading = false; // 데이터 로딩이 완료");
  }

  Future<void> getBehaviorList(List studentList) async {
    if (!isLoading) {
      return; // 이미 데이터 로딩이 완료된 경우 중복 호출 방지
    }
    for (var student in studentList) {
      await FirebaseFirestore.instance
          .collection("Record")
          .doc(student)
          .collection("Behavior")
          .get()
          .then((valueList) {
        dynamic temp = [];
        for (var element in valueList.docs) {
          temp.add(element.id);
        }
        itemContentList.add(temp);
      });
    }
    isLoading = false; // 데이터 로딩이 완료되었음을 표시
    setState(() {}); // 화면을 다시 그리도록 강제 업데이트
  }

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
          .collection('Order')
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

    return valuesList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final authentication = FirebaseAuth.instance;
    user = authentication.currentUser!;
    uid = user.uid; //현재 접속한 유저의 UID 할당

    getEducator(uid).then((value) {
      //학생이름_행동명 : 학생ID Map

      for (int i = 0; i < itemContentList.length; i++) {
        for (int j = 0; j < itemContentList[i].length; j++) {
          print("배열안에 배열 출력 ${itemContentList[i][j]}");
          print(studentDataList[i].values.first);
          print(studentList[i]);
          stdNamebhvNameTostdID.add({
            "${studentDataList[i].values.first}_${itemContentList[i][j]}":
                studentList[i]
          });
          numOfCards++;
        }
      }
      print("item length $numOfCards");

      for (int i = 0; i < numOfCards; i++) {
        names.add(stdNamebhvNameTostdID[i].keys.first.split("_")[0]);
        String tmp = stdNamebhvNameTostdID[i].keys.first.split("_")[0];
        LastNames.add(tmp[0]);
        print(tmp[0]);
        behaviors.add(stdNamebhvNameTostdID[i].keys.first.split("_")[1]);
        studentIDs.add(stdNamebhvNameTostdID[i].values.first);
      }

      buildBehaviorCards(behaviorList: itemContentList);
    });
  }

  @override
  Widget build(BuildContext context) {
    ///바텀 네비게이션
    widgetOptions = <Widget>[
      HomeScreen(
          studentDataList: studentDataList,
          studentIdList: studentList,
          itemContentList: itemContentList),
      const CalendarManageScreen(),
      BehavirRecordScreen(
        studentIDs: studentIDs,
        names: names,
        behaviors: behaviors,
        cards: buildBehaviorCards(behaviorList: itemContentList),
      ),
      const DashBoardScreen(),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            widgetOptions.elementAt(_selected_screen),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomBarItems,
        currentIndex: _selected_screen,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  ///학생의 이름, 행동, 행동유형을 기반으로 행동 카드를 생성해주는 메서드
  ///아래부터의 코드는 behavior_record.dart에서 작동하는 파일임.
  ///
  ///
  ///
  Future<void> recordBahvior({
    required String? behaivorName,
    required String? studentID,
  }) async {
    // 현재 시간을 가져오기
    DateTime now = DateTime.now();
    // 도큐먼트 ID로 사용할 문자열을 생성

    try {
      await db
          .collection('Record')
          .doc(studentID)
          .collection('Behavior')
          .doc(behaivorName)
          .collection('BehaviorRecord')
          .doc(now.toString())
          .set({}, SetOptions(merge: true));
    } catch (e) {
      print('Failed to add document: $e');
    }
  }

  Widget buildBehaviorCards({required List behaviorList}) {
    ///내 계정에 등록된 아이의 ID를 가져오는 스냅샷
    QuerySnapshot? snapshotStudents;

    DocumentSnapshot? snapshotTempBehavior;
    DocumentSnapshot? snapshotTempStudent;

    print("itemContentList: $itemContentList");
    print("behaviorList: $behaviorList");
    print("studentList: $studentList");
    print("studentIdList: $studentIdList");
    print("studentDataList: $studentDataList");

    print("행동 아이디 수 ${itemContentList.length}");

    //행동의 개수에 따라 다른 화면을 보여주기 위한 swtich 문
    switch (numOfCards) {
      case 0:
        return const Expanded(
          child: Center(
            child: Text("아동 데이터 또는 행동 데이터가 없습니다."),
          ),
        );

      // case 1:
      //   return LayoutBuilder(
      //     builder: (BuildContext context, BoxConstraints constraints) {
      //       print(
      //           'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
      //       return Container(
      //         child: Column(
      //           children: [
      //             Row(
      //               children: [
      //                 //first bahavior
      //                 GestureDetector(
      //                   onTap: () async {
      //                     await recordBahvior(
      //                       behaviorID: behaviorList[0],
      //                       studentID: behaviorIDAndStudentID[behaviorList[0]],
      //                     );
      //                     setState(() {});
      //                   },
      //                   child: Container(
      //                     margin: const EdgeInsets.all(10),
      //                     height: constraints.maxHeight - 20,
      //                     width: constraints.maxWidth - 20,
      //                     padding: const EdgeInsets.all(20),
      //                     decoration: BoxDecoration(
      //                         borderRadius: const BorderRadius.all(
      //                           Radius.circular(15),
      //                         ),
      //                         color: const Color.fromRGBO(195, 255, 250, 1),
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color: Colors.grey.withOpacity(0.5),
      //                             spreadRadius: 0,
      //                             blurRadius: 5,
      //                             offset: const Offset(
      //                                 0, 10), // changes position of shadow
      //                           ),
      //                         ]),
      //                     child: Center(
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Container(
      //                             child: Row(
      //                               mainAxisAlignment: MainAxisAlignment.center,
      //                               children: [
      //                                 Container(
      //                                   height: 40,
      //                                   width: 40,
      //                                   decoration: const BoxDecoration(
      //                                     shape: BoxShape.circle,
      //                                     color: Colors.white60,
      //                                   ),
      //                                   child: Center(
      //                                     child: Text(
      //                                         "${stdNamebhvNameTostdID[0].keys.first.split('_')[0]}"),
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   "  ${mapForBehaviorsData[behaviorList[0]]!.values.first}",
      //                                   style: const TextStyle(
      //                                       fontWeight: FontWeight.w300),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                           Container(
      //                             child: Text(
      //                               mapForBehaviorsData[behaviorList[0]]!
      //                                   .keys
      //                                   .first,
      //                               style: const TextStyle(
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   );
      // case 2:
      //   return LayoutBuilder(
      //     builder: (BuildContext context, BoxConstraints constraints) {
      //       print(
      //           'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
      //       return Container(
      //         child: Column(
      //           children: [
      //             GestureDetector(
      //               onTap: () async {
      //                 await recordBahvior(
      //                   behaviorID: behaviorList[0],
      //                   studentID: behaviorIDAndStudentID[behaviorList[0]],
      //                 );
      //                 setState(() {});
      //               },
      //               child: Container(
      //                 margin: const EdgeInsets.all(10),
      //                 height: constraints.maxHeight / 2 - 20,
      //                 width: constraints.maxWidth - 20,
      //                 padding: const EdgeInsets.all(20),
      //                 decoration: BoxDecoration(
      //                     borderRadius: const BorderRadius.all(
      //                       Radius.circular(15),
      //                     ),
      //                     color: const Color.fromRGBO(195, 255, 250, 1),
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.grey.withOpacity(0.5),
      //                         spreadRadius: 0,
      //                         blurRadius: 5,
      //                         offset: const Offset(
      //                             0, 10), // changes position of shadow
      //                       ),
      //                     ]),
      //                 child: Center(
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Container(
      //                         child: Row(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           children: [
      //                             Container(
      //                               height: 40,
      //                               width: 40,
      //                               decoration: const BoxDecoration(
      //                                 shape: BoxShape.circle,
      //                                 color: Colors.white60,
      //                               ),
      //                               child: Center(
      //                                 child: Text(
      //                                     "${stdNamebhvNameTostdID[0].keys.first.split('_')[0]}"),
      //                               ),
      //                             ),
      //                             Text(
      //                               "  ${mapForBehaviorsData[behaviorList[0]]!.values.first}",
      //                               style: const TextStyle(
      //                                   fontWeight: FontWeight.w300),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       Container(
      //                         child: Text(
      //                           stdNamebhvNameTostdID[0]
      //                               .keys
      //                               .first
      //                               .split('_')[1],
      //                           style: const TextStyle(
      //                               fontWeight: FontWeight.bold),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             //두번째 카드
      //             GestureDetector(
      //               onTap: () async {
      //                 await recordBahvior(
      //                   behaviorID: behaviorList[1],
      //                   studentID: behaviorIDAndStudentID[behaviorList[1]],
      //                 );
      //                 setState(() {});
      //               },
      //               child: Container(
      //                 margin: const EdgeInsets.all(10),
      //                 height: constraints.maxHeight / 2 - 20,
      //                 width: constraints.maxWidth - 20,
      //                 padding: const EdgeInsets.all(20),
      //                 decoration: BoxDecoration(
      //                     borderRadius: const BorderRadius.all(
      //                       Radius.circular(15),
      //                     ),
      //                     color: const Color.fromRGBO(195, 255, 250, 1),
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.grey.withOpacity(0.5),
      //                         spreadRadius: 0,
      //                         blurRadius: 5,
      //                         offset: const Offset(
      //                             0, 10), // changes position of shadow
      //                       ),
      //                     ]),
      //                 child: Center(
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Container(
      //                         child: Row(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           children: [
      //                             Container(
      //                               height: 40,
      //                               width: 40,
      //                               decoration: const BoxDecoration(
      //                                 shape: BoxShape.circle,
      //                                 color: Colors.white60,
      //                               ),
      //                               child: Center(
      //                                 child: Text(
      //                                     mapForBehaviorsData[behaviorList[1]]!
      //                                         .values
      //                                         .first[0]),
      //                               ),
      //                             ),
      //                             Text(
      //                                 "${stdNamebhvNameTostdID[1].keys.first.split('_')[0]}"),
      //                           ],
      //                         ),
      //                       ),
      //                       Container(
      //                         child: Text(
      //                           stdNamebhvNameTostdID[1]
      //                               .keys
      //                               .first
      //                               .split('_')[1],
      //                           style: const TextStyle(
      //                               fontWeight: FontWeight.bold),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   );
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
                      await recordBahvior(
                        behaivorName: behaviors[0],
                        studentID: studentIDs[0],
                      );
                      setState(() {});
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
                                      child: Text(LastNames[0]),
                                    ),
                                  ),
                                  Text(
                                    names[0],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                behaviors[0],
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
                      await recordBahvior(
                        behaivorName: behaviors[1],
                        studentID: studentIDs[1],
                      );
                      setState(() {});
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
                                      child: Text(LastNames[1]),
                                    ),
                                  ),
                                  Text(
                                    names[1],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                behaviors[1],
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
                      await recordBahvior(
                        behaivorName: behaviors[2],
                        studentID: studentIDs[2],
                      );
                      setState(() {});
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
                                      child: Text(LastNames[2]),
                                    ),
                                  ),
                                  Text(
                                    names[2],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                behaviors[2],
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
      // case 4:
      //   // key를 사용하여 behaviorIDAndStudentID에서 value를 가져옴
      //   return LayoutBuilder(
      //     builder: (BuildContext context, BoxConstraints constraints) {
      //       print(
      //           'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
      //       return Container(
      //         child: Column(
      //           children: [
      //             Row(
      //               children: [
      //                 // 첫번째 카드
      //                 GestureDetector(
      //                   onTap: () async {
      //                     recordBahvior(
      //                       behaviorID: behaviorList[0],
      //                       studentID: behaviorIDAndStudentID[behaviorList[0]],
      //                     );
      //                   },
      //                   child: Container(
      //                     margin: const EdgeInsets.all(10),
      //                     height: constraints.maxHeight / 2 - 20,
      //                     width: constraints.maxWidth / 2 - 20,
      //                     padding: const EdgeInsets.all(20),
      //                     decoration: BoxDecoration(
      //                         borderRadius: const BorderRadius.all(
      //                           Radius.circular(15),
      //                         ),
      //                         color: const Color.fromRGBO(195, 255, 250, 1),
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color: Colors.grey.withOpacity(0.5),
      //                             spreadRadius: 0,
      //                             blurRadius: 5,
      //                             offset: const Offset(
      //                                 0, 10), // changes position of shadow
      //                           ),
      //                         ]),
      //                     child: Center(
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Container(
      //                             child: Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceEvenly,
      //                               children: [
      //                                 Container(
      //                                   height: 40,
      //                                   width: 40,
      //                                   decoration: const BoxDecoration(
      //                                     shape: BoxShape.circle,
      //                                     color: Colors.white60,
      //                                   ),
      //                                   child: Center(
      //                                     child: Text(mapForBehaviorsData[
      //                                             behaviorList[0]]!
      //                                         .values
      //                                         .first[0]),
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   "  ${mapForBehaviorsData[behaviorList[0]]!.values.first}",
      //                                   style: const TextStyle(
      //                                       fontWeight: FontWeight.w300),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                           Container(
      //                             child: Text(
      //                               mapForBehaviorsData[behaviorList[0]]!
      //                                   .keys
      //                                   .first,
      //                               style: const TextStyle(
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 //두번째 카드
      //                 GestureDetector(
      //                   onTap: () async {
      //                     recordBahvior(
      //                       behaviorID: behaviorList[1],
      //                       studentID: behaviorIDAndStudentID[behaviorList[1]],
      //                     );
      //                   },
      //                   child: Container(
      //                     margin: const EdgeInsets.all(10),
      //                     height: constraints.maxHeight / 2 - 20,
      //                     width: constraints.maxWidth / 2 - 20,
      //                     padding: const EdgeInsets.all(20),
      //                     decoration: BoxDecoration(
      //                         borderRadius: const BorderRadius.all(
      //                           Radius.circular(15),
      //                         ),
      //                         color: const Color.fromRGBO(195, 255, 250, 1),
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color: Colors.grey.withOpacity(0.5),
      //                             spreadRadius: 0,
      //                             blurRadius: 5,
      //                             offset: const Offset(
      //                                 0, 10), // changes position of shadow
      //                           ),
      //                         ]),
      //                     child: Center(
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Container(
      //                             child: Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceEvenly,
      //                               children: [
      //                                 Container(
      //                                   height: 40,
      //                                   width: 40,
      //                                   decoration: const BoxDecoration(
      //                                     shape: BoxShape.circle,
      //                                     color: Colors.white60,
      //                                   ),
      //                                   child: Center(
      //                                     child: Text(mapForBehaviorsData[
      //                                             behaviorList[1]]!
      //                                         .values
      //                                         .first[0]),
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   "  ${mapForBehaviorsData[behaviorList[1]]!.values.first}",
      //                                   style: const TextStyle(
      //                                       fontWeight: FontWeight.w300),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                           Container(
      //                             child: Text(
      //                               mapForBehaviorsData[behaviorList[1]]!
      //                                   .keys
      //                                   .first,
      //                               style: const TextStyle(
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Row(
      //               children: [
      //                 //3번째 행동 카드
      //                 GestureDetector(
      //                   onTap: () async {
      //                     recordBahvior(
      //                       behaviorID: behaviorList[2],
      //                       studentID: behaviorIDAndStudentID[behaviorList[2]],
      //                     );
      //                   },
      //                   child: Container(
      //                     margin: const EdgeInsets.all(10),
      //                     height: constraints.maxHeight / 2 - 20,
      //                     width: constraints.maxWidth / 2 - 20,
      //                     padding: const EdgeInsets.all(20),
      //                     decoration: BoxDecoration(
      //                         borderRadius: const BorderRadius.all(
      //                           Radius.circular(15),
      //                         ),
      //                         color: const Color.fromRGBO(195, 255, 250, 1),
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color: Colors.grey.withOpacity(0.5),
      //                             spreadRadius: 0,
      //                             blurRadius: 5,
      //                             offset: const Offset(
      //                                 0, 10), // changes position of shadow
      //                           ),
      //                         ]),
      //                     child: Center(
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Container(
      //                             child: Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceEvenly,
      //                               children: [
      //                                 Container(
      //                                   height: 40,
      //                                   width: 40,
      //                                   decoration: const BoxDecoration(
      //                                     shape: BoxShape.circle,
      //                                     color: Colors.white60,
      //                                   ),
      //                                   child: Center(
      //                                     child: Text(mapForBehaviorsData[
      //                                             behaviorList[2]]!
      //                                         .values
      //                                         .first[0]),
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   "  ${mapForBehaviorsData[behaviorList[2]]!.values.first}",
      //                                   style: const TextStyle(
      //                                       fontWeight: FontWeight.w300),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                           Container(
      //                             child: Text(
      //                               mapForBehaviorsData[behaviorList[2]]!
      //                                   .keys
      //                                   .first,
      //                               style: const TextStyle(
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 //4번째
      //                 GestureDetector(
      //                   onTap: () async {
      //                     recordBahvior(
      //                       behaviorID: behaviorList[3],
      //                       studentID: behaviorIDAndStudentID[behaviorList[3]],
      //                     );
      //                   },
      //                   child: Container(
      //                     margin: const EdgeInsets.all(10),
      //                     height: constraints.maxHeight / 2 - 20,
      //                     width: constraints.maxWidth / 2 - 20,
      //                     padding: const EdgeInsets.all(20),
      //                     decoration: BoxDecoration(
      //                         borderRadius: const BorderRadius.all(
      //                           Radius.circular(15),
      //                         ),
      //                         color: const Color.fromRGBO(195, 255, 250, 1),
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color: Colors.grey.withOpacity(0.5),
      //                             spreadRadius: 0,
      //                             blurRadius: 5,
      //                             offset: const Offset(
      //                                 0, 10), // changes position of shadow
      //                           ),
      //                         ]),
      //                     child: Center(
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Container(
      //                             child: Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceEvenly,
      //                               children: [
      //                                 Container(
      //                                   height: 40,
      //                                   width: 40,
      //                                   decoration: const BoxDecoration(
      //                                     shape: BoxShape.circle,
      //                                     color: Colors.white60,
      //                                   ),
      //                                   child: Center(
      //                                     child: Text(mapForBehaviorsData[
      //                                             behaviorList[3]]!
      //                                         .values
      //                                         .first[0]),
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   "  ${mapForBehaviorsData[behaviorList[3]]!.values.first}",
      //                                   style: const TextStyle(
      //                                       fontWeight: FontWeight.w300),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                           Container(
      //                             child: Text(
      //                               mapForBehaviorsData[behaviorList[3]]!
      //                                   .keys
      //                                   .first,
      //                               style: const TextStyle(
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   );
    }

    return Container();
  }
}
