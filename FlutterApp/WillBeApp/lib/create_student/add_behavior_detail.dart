import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution/main_feat_screens/main_page.dart';

class Add_Behavior_Detail extends StatefulWidget {
  Add_Behavior_Detail(
      {super.key,
      required this.name,
      required this.behaviorValue,
      this.id = ""});

  String? name;
  // int? schoolValue;
  // int? expValue;
  // int? selfHelpValue;
  int behaviorValue;
  String? behaviorName;
  String id;

  @override
  State<Add_Behavior_Detail> createState() => _Add_Behavior_Detail_State();
}

class _Add_Behavior_Detail_State extends State<Add_Behavior_Detail> {
  // 입력값을 추적하기 위한 controllers
  Map<String, TextEditingController> textControllers = {
    "behaviorName": TextEditingController(),
  };
  int methodValue = 0; // 초기값 (0: 횟수 / 1: 지속시간 / 2: 지연시간)
  // int functionValue = 0; // 초기값
  List<String> schoolOptions = [
    '언어적 공격(욕설, 고함)',
    '불순종',
    '과제 이탈',
    '신체적 공격(차기, 꼬집기, 때리기)',
    '기물 파괴',
    '다른 사람을 놀리거나 화나게함',
    '달아나기',
    '안절부절못함',
    '울화 터뜨리기',
    '소리 지르기',
    '기타'
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      textControllers['behaviorName']?.text =
          schoolOptions[widget.behaviorValue];
    });
  }

  void signUp() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Educator')
          .doc(user.uid)
          .set({});
    }
  }

  void createStudent() async {
    // 유저 객체
    User? user = FirebaseAuth.instance.currentUser;
    // 학생 doc 생성 (id 자동 생성)
    final docParty = FirebaseFirestore.instance.collection('Student').doc();

    // final subDocParty = FirebaseFirestore.instance
    //     .collection('Student')
    //     .doc(docParty.id)
    //     .collection('Behavior')
    //     .doc();

    if (user != null) {
      // 학생 객체 필드 데이터 저장
      await FirebaseFirestore.instance
          .collection('Student')
          .doc(docParty.id)
          .set({
        'name': widget.name,
        'educator': user.uid,
      });

      // Record collection에 학생 doc 생성
      await FirebaseFirestore.instance
          .collection('Record')
          .doc(docParty.id)
          .set({});

      // Record 컬렉션 내 Behavior 세팅
      await FirebaseFirestore.instance
          .collection('Record')
          .doc(docParty.id)
          .collection('Behavior')
          .doc(widget.behaviorName)
          .set({});

      // Record 컬렉션 내 Behavior 유형 등록
      await FirebaseFirestore.instance
          .collection('Record')
          .doc(docParty.id)
          .collection('Behavior')
          .doc(widget.behaviorName)
          .set({'method': methodValue}); // (0: 횟수 / 1: 지속시간 / 2: 지연시간)

      // Record 컬렉션 내 Report doc 생성
      await FirebaseFirestore.instance
          .collection('Record')
          .doc(docParty.id)
          .collection('Report')
          .doc(user.uid)
          .set({});

      // Record 컬렉션 내 Report 세팅 (Daily)
      await FirebaseFirestore.instance
          .collection('Record')
          .doc(docParty.id)
          .collection('Report')
          .doc(user.uid)
          .collection("Daily")
          .doc(widget.behaviorName)
          .set({});

      // Record 컬렉션 내 Report 세팅 (Weekly)
      await FirebaseFirestore.instance
          .collection('Record')
          .doc(docParty.id)
          .collection('Report')
          .doc(user.uid)
          .collection("Weekly")
          .doc(widget.behaviorName)
          .set({});

      await FirebaseFirestore.instance
          .collection('Educator')
          .doc(user.uid)
          .collection('Order')
          .doc('OrderList')
          .get()
          .then((querySnapshot) {
        Map<String, dynamic>? updates = {};
        updates = querySnapshot.data();
        if (updates == null) {
          updates = {"OrderList": []};
        }
        updates["OrderList"].add('${docParty.id}_${widget.behaviorName}');

        FirebaseFirestore.instance
            .collection('Educator')
            .doc(user.uid)
            .collection('Order')
            .doc('OrderList')
            .set(
              updates,
            );
      });

      // 교사 컬렉션 내 Timetable doc 생성
      await FirebaseFirestore.instance
          .collection('Educator')
          .doc(user.uid)
          .collection('Schedule')
          .doc('Timetable')
          .set({});

      List weekList = ['Mon', 'Tue', "Wed", "Thu", "Fri"];
      // 교사 컬렉션 내 Schedule 등록
      for (var day in weekList) {
        await FirebaseFirestore.instance
            .collection('Educator')
            .doc(user.uid)
            .collection('Schedule')
            .doc('Timetable')
            .collection("Routine")
            .doc(day)
            .set({});
      }

      // 교사 내 학생 id 등록
      await FirebaseFirestore.instance
          .collection('Educator')
          .doc(user.uid)
          .collection('Student')
          .doc(docParty.id)
          .set({});
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Main_Page(),
      ),
      (route) => false,
    );
  }

  void addBehavior() async {
    User? user = FirebaseAuth.instance.currentUser;
    // Record 컬렉션 내 Behavior 세팅
    await FirebaseFirestore.instance
        .collection('Record')
        .doc(widget.id)
        .collection('Behavior')
        .doc(widget.behaviorName)
        .set({});

    // Record 컬렉션 내 Behavior 유형 등록
    await FirebaseFirestore.instance
        .collection('Record')
        .doc(widget.id)
        .collection('Behavior')
        .doc(widget.behaviorName)
        .set({'method': methodValue}); // (0: 횟수 / 1: 지속시간 / 2: 지연시간)

    // Record 컬렉션 내 Report 세팅 (Daily)
    await FirebaseFirestore.instance
        .collection('Record')
        .doc(widget.id)
        .collection('Report')
        .doc(user!.uid)
        .collection("Daily")
        .doc(widget.behaviorName)
        .set({});

    // Record 컬렉션 내 Report 세팅 (Weekly)
    await FirebaseFirestore.instance
        .collection('Record')
        .doc(widget.id)
        .collection('Report')
        .doc(user.uid)
        .collection("Weekly")
        .doc(widget.behaviorName)
        .set({});

    await FirebaseFirestore.instance
        .collection('Educator')
        .doc(user.uid)
        .collection('Order')
        .doc('OrderList')
        .get()
        .then((querySnapshot) {
      Map<String, dynamic>? updates = {};
      updates = querySnapshot.data();
      if (updates == null) {
        updates = {"OrderList": []};
      }
      updates["OrderList"].add('${widget.id}_${widget.behaviorName}');

      FirebaseFirestore.instance
          .collection('Educator')
          .doc(user.uid)
          .collection('Order')
          .doc('OrderList')
          .set(
            updates,
          );
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Main_Page(),
      ),
      (route) => false,
    );
  }

  void _submitData() async {
    print([
      widget.name,
      widget.behaviorValue,
      widget.behaviorName,
    ]);
    if (widget.name == "" ||
        widget.behaviorValue == null ||
        widget.behaviorName == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('측정할 도전행동의 세부사항을 작성해주세요!')));
      return;
    } else {
      return showDialog<void>(
        //다이얼로그 위젯 소환
        context: context,
        barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: SizedBox(
              height: 30,
              child: Image.asset(
                'assets/icons/willbe.png',
                fit: BoxFit.contain,
              ),
            ),
            content: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: const Text(
                    '아이 등록을 완료할까요?',
                    textAlign: TextAlign.center,
                  )),
            ),
            actions: [
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 102, 108, 255),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(4.0),
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () async {
                        //firestore에 관련된 인스턴스들
                        User? _user = FirebaseAuth.instance.currentUser;

                        // currentUser가 있는지 확인
                        if (_user != null) {
                          final docSnapshot = await FirebaseFirestore.instance
                              .collection('Educator')
                              .doc(_user!.uid)
                              .get();
                          //파이어베이스에 등록이 되어있는지 확인
                          if (!(docSnapshot.exists)) {
                            signUp();
                          }
                        }
                        if (widget.id == "") {
                          createStudent();
                        } else {
                          addBehavior();
                        }
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
    // 알림창 띄우기 -> 확인 버튼 누르면 DB에 객체 생성
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    widget.behaviorName = textControllers["behaviorName"]?.text;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                  ),
                  child: const Text(
                    "측정할 측정행동의 세부사항을\n작성해주세요",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  style: const TextStyle(
                    height: 1.5,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    floatingLabelStyle: TextStyle(
                      color: Color.fromARGB(255, 102, 108, 255),
                      fontWeight: FontWeight.w500,
                      fontSize: 23,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: '행동 이름',
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: -20, bottom: 4),
                    focusColor: Color.fromARGB(255, 102, 108, 255),
                    labelStyle: TextStyle(
                      fontSize: 25,
                      color: Colors.black26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controller: textControllers["behaviorName"],
                  onChanged: (value) {
                    setState(() {
                      widget.behaviorName = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width - 32,
                child: const Text(
                  "정확히 어떤 행동을 말하는지 작성해주세요.\n ∙ 예시) 천장을 보고 욕설을 내뱉는 행동",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, color: Colors.black26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                  ),
                  child: const Text(
                    "측정 방식",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 102, 108, 255),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 100.0, // 원하는 높이로 조절
                  child: CupertinoSlidingSegmentedControl(
                    groupValue: methodValue,
                    thumbColor: const Color.fromRGBO(211, 211, 211, 1),
                    padding: const EdgeInsets.all(7),
                    children: const {
                      0: SizedBox(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          '횟수',
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                      1: SizedBox(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          '지속시간',
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                      2: SizedBox(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          '지연시간',
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        methodValue = value as int;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 32,
                child: const Text(
                  "행동을 한 횟수로 측정해요.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, color: Colors.black26),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width - 32,
              //     padding: const EdgeInsets.only(
              //       top: 16,
              //       bottom: 8,
              //     ),
              //     child: const Text(
              //       "추정되는 기능",
              //       textAlign: TextAlign.left,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //         color: Color.fromARGB(255, 102, 108, 255),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: SizedBox(
              //     width: double.infinity,
              //     height: 100.0, // 원하는 높이로 조절
              //     child: CupertinoSlidingSegmentedControl(
              //       groupValue: functionValue,
              //       thumbColor: const Color.fromRGBO(211, 211, 211, 1),
              //       padding: const EdgeInsets.all(7),
              //       children: const {
              //         0: SizedBox(
              //           height: 50.0,
              //           child: Center(
              //               child: Text(
              //             '유형물/활동의 획득',
              //             style: TextStyle(fontSize: 15),
              //           )),
              //         ),
              //         1: SizedBox(
              //           height: 50.0,
              //           child: Center(
              //               child: Text(
              //             '사회적 자극',
              //             style: TextStyle(fontSize: 15),
              //           )),
              //         ),
              //         2: SizedBox(
              //           height: 50.0,
              //           child: Center(
              //               child: Text(
              //             '감각자극',
              //             style: TextStyle(fontSize: 15),
              //           )),
              //         ),
              //       },
              //       onValueChanged: (value) {
              //         setState(() {
              //           functionValue = value as int;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  _submitData();
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  color: const Color.fromARGB(255, 102, 108, 255),
                  child: const Center(
                    child: Text(
                      '등록하고 측정하러 가기',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
