import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution/main_feat_screens/main_page.dart';

class Add_Behavior_Detail extends StatefulWidget {
  Add_Behavior_Detail(
      {Key? key,
      required this.name,
      required this.schoolValue,
      required this.expValue,
      required this.selfHelpValue,
      required this.behaviorValue});

  String? name;
  int? schoolValue;
  int? expValue;
  int? selfHelpValue;
  int? behaviorValue;
  String? behaviorName;

  @override
  State<Add_Behavior_Detail> createState() => _Add_Behavior_Detail_State();
}

class _Add_Behavior_Detail_State extends State<Add_Behavior_Detail> {
  // 입력값을 추적하기 위한 controllers
  Map<String, TextEditingController> textControllers = {
    "behaviorName": TextEditingController(),
  };
  int methodValue = 0; // 초기값
  int functionValue = 0; // 초기값

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
    User? user = FirebaseAuth.instance.currentUser;
    final docParty = FirebaseFirestore.instance.collection('Student').doc();
    final subDocParty = FirebaseFirestore.instance
        .collection('Student')
        .doc(docParty.id)
        .collection('Behavior')
        .doc();
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Student')
          .doc(docParty.id)
          .set({
        'name': widget.name,
        'schoolValue': widget.schoolValue,
        'level': {
          'expression': widget.expValue,
          'selfHelp': widget.selfHelpValue
        },
        'educator': user.uid,
      });
      await FirebaseFirestore.instance
          .collection('Student')
          .doc(docParty.id)
          .collection('Behavior')
          .doc(subDocParty.id)
          .set({
        'behaviorName': widget.behaviorName,
        'behaviorType': widget.behaviorValue,
      });

      ///주석으로 감싸진 코드 조기홍이 추가
      await FirebaseFirestore.instance
          .collection('Educator')
          .doc(user.uid)
          .collection('Order')
          .doc(docParty.id)
          .set({subDocParty.id: "1"});

      ///

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
        builder: (context) => Main_Page(),
      ),
      (route) => false,
    );
  }

  void _submitData() async {
    print([
      widget.name,
      widget.schoolValue,
      widget.expValue,
      widget.selfHelpValue,
      widget.behaviorValue,
      widget.behaviorName,
    ]);
    if (widget.name == "" ||
        widget.schoolValue == null ||
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
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    '아이 등록을 완료할까요?',
                    textAlign: TextAlign.center,
                  )),
            ),
            actions: [
              TextButton(
                child: Text(
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
                        signUp();
                        createStudent();
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
    widget.behaviorName = textControllers["behaviorName"]?.text;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    "측정할 측정행동의 세부사항을\n작성해주세요",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  style: TextStyle(
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
                child: Text(
                  "정확히 어떤 행동을 말하는지 작성해주세요.\n ∙ 예시) 천장을 보고 욕설을 내뱉는 행동",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, color: Colors.black26),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
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
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 100.0, // 원하는 높이로 조절
                  child: CupertinoSlidingSegmentedControl(
                    groupValue: methodValue,
                    thumbColor: Color.fromRGBO(211, 211, 211, 1),
                    padding: EdgeInsets.all(7),
                    children: {
                      0: Container(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          '횟수',
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                      1: Container(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          '지속시간',
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                      2: Container(
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
                child: Text(
                  "행동을 한 횟수로 측정해요.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, color: Colors.black26),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    "추정되는 기능",
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
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 100.0, // 원하는 높이로 조절
                  child: CupertinoSlidingSegmentedControl(
                    groupValue: functionValue,
                    thumbColor: Color.fromRGBO(211, 211, 211, 1),
                    padding: EdgeInsets.all(7),
                    children: {
                      0: Container(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          '유형물/활동의 획득',
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                      1: Container(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          '사회적 자극',
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                      2: Container(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          '감각자극',
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        functionValue = value as int;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _submitData();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 32),
                  color: Color.fromARGB(255, 102, 108, 255),
                  child: Center(
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
