///이 파일은 사용자가 로그인 후 최초 보여지는 화면입니다.
///로그아웃 버튼을 클릭 시 자동로그인이 풀리며 사용자의 계정 정보는 앱에서 지워지게 됩니다.
///따라서 다시 로그인을 해야합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
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

  ///하단 네비게이션 바를 위한 인데스
  int _selected_screen = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
  User? user;
  //UID of logged in user
  String? uid;
  //Data of logged in user
  Object? userData = {};
  List studentList = [];
  List studentDataList = [];
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
    CollectionReference educatorCollectionRef = await FirebaseFirestore.instance
        .collection('Educator')
        .doc(uid)
        .collection('Student');

    // 찾은 객체의 학생 리스트 get (문서 id)
    await educatorCollectionRef.get().then(
      (documentSnapshot) {
        // 리스트로 변환
        studentList = documentSnapshot.docs.map((doc) => doc.id).toList();
        // 디버깅 print
        print("HELELO");
        print(studentList);
        // 학생 데이터 추출 함수 호출
      },
      onError: (e) => print("Error completing: $e"),
    );
    getStudentData(studentList);
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

    for (var student in studentList) {
      await db.collection("Student").doc(student).get().then((querySnapshot) {
        final temp = querySnapshot.data();
        studentDataList.add(temp);
      });
    }
    print("Hello");
    print(studentDataList);

    isLoading = false; // 데이터 로딩이 완료되었음을 표시
    setState(() {}); // 화면을 다시 그리도록 강제 업데이트
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///바텀 네비게이션
    List<Widget> widgetOptions = <Widget>[
      HomeScreen(studentDataList: studentDataList),
      const CalendarManageScreen(),
      BehavirRecordScreen(
        studentDataList: studentDataList,
      ),
      const DashBoardScreen(),
    ];

    final authentication = FirebaseAuth.instance;
    user = authentication.currentUser;
    uid = user?.uid; //현재 접속한 유저의 UID 할당
    getEducator(uid);
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
}
