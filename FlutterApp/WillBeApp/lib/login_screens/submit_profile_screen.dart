import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solution/login_screens/auto_complete.dart';
import 'package:solution/main_feat_screens/main_page.dart';

class Submit_Profile_Screen extends StatefulWidget {
  Submit_Profile_Screen({super.key, required this.role});

  final String role;
  var name = "";
  String school = "";
  void getSelection(String val) {
    school = val;
    print('Hello = $val');
  }

  final List<String> schoolList = [
    //서울지역 시작
    '광성하늘빛학교',
    '교남학교',
    '누리학교',
    '다니엘학교',
    '동진학교',
    '밀알학교',
    '새롬학교',
    '서울경운학교',
    '서울광진학교',
    '서울나래학교',
    '서울농학교',
    '서울다원학교',
    '서울도솔학교',
    '서울동천학교',
    '서울맹학교',
    '서울삼성학교',
    '서울서진학교',
    '서울애화학교',
    '서울정문학교',
    '서울정민학교',
    '서울정애학교',
    '서울정인학교',
    '서울정진학교',
    '서울효정학교',
    '성 베드로 학교',
    '수도사랑의학교',
    '연세대학교재활학교',
    '은평대영학교',
    '주몽학교',
    '한국구화학교',
    '한국우진학교',
    '한국육영학교',
    '한빛맹학교',
    // 서울지역 끝

    '대전가원학교', //대전 시작
    '대전맹학교',
    '대전성세재활학교',
    '대전원명학교',
    '대전해든학교',
    '대전혜광학교', //대전 끝
  ];

  List<String> grades = ['1', '2', '3', '4', '5', '6'];
  List<String> classNums = ['1', '2', '3', '4', '5', '6', '7'];
  String? grade = "1";
  String? classNum = "1";
  @override
  State<Submit_Profile_Screen> createState() => _Submit_Profile_ScreenState();
}

class _Submit_Profile_ScreenState extends State<Submit_Profile_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  ///회원가입 메서드.
  void signUp(
      {required String role,
      required String name,
      required String school,
      required String? grade,
      required String? classNum}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Educator')
          .doc(user.uid)
          .set({
        'role': role,
        'name': name,
        'school': school,
        'class': '$grade-$classNum',
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Main_Page(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 10,
                  ),
                  Text(
                    widget.role,
                    style: const TextStyle(color: Colors.amber, fontSize: 40),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 10,
                  ),
                  const Text(
                    "이름",
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextField(
                        onChanged: (text) {
                          widget.name = text;
                        },
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      )),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 10,
                  ),
                  const Text(
                    "학교 이름",
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: buildAutocomplete(widget.schoolList,
                          (String selectedValue) {
                        widget.school = selectedValue;
                      })), //학교 입력창. 자동완성 기능

                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 10,
                  ),
                  const Text(
                    "학년",
                  ),
                  DropdownButton(
                    value: widget.grade ?? widget.grades.first,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        widget.grade = value!;
                      });
                    },
                    items: widget.grades.map((value) {
                      return (DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ));
                    }).toList(),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 10,
                  ),
                  const Text(
                    "학급",
                  ),
                  DropdownButton(
                    value: widget.classNum ?? widget.classNums.first,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        widget.classNum = value!;
                      });
                    },
                    items: widget.classNums.map((value) {
                      return (DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ));
                    }).toList(),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        signUp(
                          role: widget.role,
                          name: widget.name,
                          school: widget.school,
                          grade: widget.grade,
                          classNum: widget.classNum,
                        );
                      },
                      child: const Text("Sign Up")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
