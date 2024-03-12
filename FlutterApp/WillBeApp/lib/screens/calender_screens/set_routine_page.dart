import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution/screens/main_page.dart';
import 'package:solution/features/timetable.dart';
import 'package:solution/assets/pallet.dart';

class SetRoutinePage extends StatefulWidget {
  SetRoutinePage({super.key, required this.cellMap});
  Map<String, dynamic> cellMap = {};
  @override
  State<SetRoutinePage> createState() => _SetRoutinePageState();
}

User? _user = FirebaseAuth.instance.currentUser;

// 과목 색 class
SubjectColors subjectColors = SubjectColors();

List subjectList = ['수학', '체육', '말듣쓰', '음악', '실과'];

class _SetRoutinePageState extends State<SetRoutinePage> {
  int subjectValue = 0;

  void changeSubject(int newSubjectValue) {
    if (newSubjectValue == -1) {
      return;
    }
    setState(() {
      subjectValue = newSubjectValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 버튼을 눌렀을 때 수행할 동작을 정의
        bool shouldPop = await _showExitConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).height - 16,
                  child: Text(
                    '루틴 설정',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 16,
                  height: MediaQuery.sizeOf(context).height / 1.8,
                  child: Timetable(
                    subjectValue: subjectValue,
                    changeSubject: changeSubject,
                    cellMap: widget.cellMap,
                    subjectList: subjectList,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                for (int i = 0; i < subjectList.length; i++)
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 12, bottom: 10),
                                    child: CustomRadioButton(
                                      idx: i,
                                      isSelected: subjectValue == i,
                                      onTap: () {
                                        changeSubject(i);
                                      },
                                      text: subjectList[i],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
                    '루틴 설정을 완료할까요?',
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Main_Page(),
                    ),
                    (route) => false,
                  );
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 22, 72, 99),
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
                        if (_user != null) {
                          DocumentReference timetableRef = FirebaseFirestore
                              .instance
                              .collection('Educator')
                              .doc(_user!.uid)
                              .collection('Schedule')
                              .doc('Timetable');

                          Map<String, dynamic> cellMapCopy =
                              Map.from(widget.cellMap);

                          cellMapCopy.forEach((key, value) {
                            if (value is Map) {
                              value.forEach((subKey, subValue) {
                                if (subValue is int) {
                                  value[subKey] = subValue.toString();
                                }
                              });
                            }
                          });

                          await timetableRef.set(cellMapCopy);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Main_Page(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String text;
  final int idx;

  CustomRadioButton({
    required this.isSelected,
    required this.onTap,
    required this.text,
    required this.idx,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          color:
              isSelected ? subjectColors.subjectColorList[idx] : Colors.black12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
