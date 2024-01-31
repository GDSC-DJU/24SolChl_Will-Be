///이 파일은 사용자가 로그인 후 최초 보여지는 화면입니다.
///로그아웃 버튼을 클릭 시 자동로그인이 풀리며 사용자의 계정 정보는 앱에서 지워지게 됩니다.
///따라서 다시 로그인을 해야합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution/login_screens/primary_login_screen.dart';
import 'package:solution/sudent_profile_page/student_profile.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({super.key});

  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
  ///Instance for firebase auth
  final _authentication = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

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
  }

  // Function : 로그인 성공 시 현재 접속중인 교사 data 가져오기
  Future<void> getEducator(String? userUid) async {
    // 현재 접속 UID 문서로 갖는 객체를 Educator collection에서 가져오기
    DocumentReference _educatorCollectionRef =
        await FirebaseFirestore.instance.collection('Educator').doc(uid);
    // 찾은 객체의 데이터 get
    DocumentSnapshot documentSnapshot = await _educatorCollectionRef.get();
    // 변수에 할당
    userData = documentSnapshot.data();
    // 디버깅 print
    print(userData);
    dynamic temp = userData;
    getStudentList(temp['school'], temp['class']);
  }

  // Function : 교사 데이터 접근 완료 시 학교 DB에서 학생 ID 가져오기
  Future<void> getStudentList(String school, String classNum) async {
    await db.collection("School").doc(school).collection(classNum).get().then(
      (querySnapshot) {
        print("Successfully completed");
        studentList = querySnapshot.docs.map((doc) => doc.id).toList();
        print(studentList);
        getStudentData(studentList);
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  bool isLoading = true;

  Future<void> getStudentData(List studentList) async {
    if (!isLoading) {
      return; // 이미 데이터 로딩이 완료된 경우 중복 호출 방지
    }

    print(studentList);

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
  Widget build(BuildContext context) {
    final authentication = FirebaseAuth.instance;
    user = authentication.currentUser;
    uid = user?.uid; //현재 접속한 유저의 UID 할당
    getEducator(uid);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildCardListView(),
          Center(
            child: OutlinedButton(
              onPressed: () async {
                await signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrimaryLoginScreen(),
                  ),
                );
              },
              child: const Text("log out"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardListView() {
    if (studentDataList.isEmpty) {
      return CircularProgressIndicator();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: (studentDataList.length / 2).ceil(),
        itemBuilder: (BuildContext context, int index) {
          return buildRowOfCards(index);
        },
      ),
    );
  }

  Widget buildRowOfCards(int rowIndex) {
    int startIndex = rowIndex * 2;
    int endIndex = (rowIndex + 1) * 2;
    endIndex =
        endIndex > studentDataList.length ? studentDataList.length : endIndex;

    List<dynamic> rowData = studentDataList.sublist(startIndex, endIndex);

    // 데이터 수가 홀수이고 현재 행이 마지막 행인 경우
    if (rowData.length % 2 == 1 &&
        rowIndex == (studentDataList.length / 2).floor()) {
      // 마지막 Card를 왼쪽 정렬
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildCard(rowData[0]),
            // 두 번째 아이템은 없으므로 비워둠
            Container(),
          ],
        ),
      );
    } else {
      // 짝수 개의 아이템인 경우나 홀수 개의 아이템인데 마지막 행이 아닌 경우
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowData.map((item) {
            return buildCard(item);
          }).toList(),
        ),
      );
    }
  }

  @override
  Widget buildCard(Object data) {
    // Object에서 필요한 필드(이름) 추출
    Map<String, dynamic> studentData = (data as Map<String, dynamic>);
    String name = studentData['name'];
    return GestureDetector(
      onTapDown: (_) {
        // 탭이 발생했을 때 해당 Card의 투명도를 낮추기
        print('onTapDown: $name');
        setState(() {
          tappedCardOpacityValue[name] = 0.3;
        });
      },
      onTapUp: (_) {
        // 탭이 해제되었을 때 해당 Card의 투명도를 초기값으로 복원
        print('onTapUp: $name');
        setState(() {
          tappedCardOpacityValue[name] = 1.0;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentProfile(
              data: studentData,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.blue.withOpacity(tappedCardOpacityValue[name] ?? 1.0),
        child: SizedBox(
          width: 150.0,
          height: 150.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$name',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Map을 사용하여 각 Card에 대한 투명도 값을 저장
  Map<String, double> tappedCardOpacityValue = {};

  double opacityValue = 1.0; // 초기 투명도 값
}
