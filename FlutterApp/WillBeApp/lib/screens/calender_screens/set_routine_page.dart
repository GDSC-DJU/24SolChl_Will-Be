///This is open source

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution/screens/main_page.dart';

class SetRoutinePage extends StatefulWidget {
  SetRoutinePage({super.key, required this.cellMap});
  Map<String, dynamic> cellMap = {};
  @override
  State<SetRoutinePage> createState() => _SetRoutinePageState();
}

User? _user = FirebaseAuth.instance.currentUser;

List subjectList = ['수학', '체육', '말듣쓰', '음악', '실과'];
List colorList = [
  Color.fromRGBO(255, 44, 75, 1),
  Color.fromRGBO(92, 182, 50, 1),
  Color.fromRGBO(60, 153, 225, 1),
  Color.fromRGBO(252, 183, 14, 1),
  Color.fromRGBO(123, 67, 183, 1),
  Color.fromRGBO(253, 151, 54, 1),
  Color.fromRGBO(45, 197, 197, 1),
];

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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 200,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                for (int i = 0; i < subjectList.length; i++)
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: 12, bottom: 10),
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
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: isSelected ? colorList[idx] : Colors.black12,
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

class Timetable extends StatefulWidget {
  Timetable({
    Key? key,
    required this.subjectValue,
    required this.changeSubject,
    this.cellMap,
  }) : super(key: key);
  Map? cellMap;
  final int subjectValue;
  final Function(int) changeSubject;

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  Map<String, dynamic> cellList = {
    "Mon": {},
    "Tue": {},
    "Wed": {},
    "Thu": {},
    "Fri": {},
  };

  @override
  void initState() {
    super.initState();
    // 초기 데이터 설정

    if (widget.cellMap != null) {
      dynamic temp = widget.cellMap;
      cellList = temp;
    } else {
      for (String day in cellList.keys) {
        for (int i = 1; i <= 9; i++) {
          if (cellList[day]['$i'] != null) {
            cellList[day]['$i'] = {
              "color": widget.subjectValue,
              "subject": subjectList[widget.subjectValue],
            };
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double cellWidth = (MediaQuery.of(context).size.width - 16) / 6.25;
    double cellHeight = MediaQuery.of(context).size.width / 10;

    List subjectList = ['수학', '체육', '말듣쓰', '음악', '실과'];
    List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    List colorList = [
      Color.fromRGBO(255, 44, 75, 1),
      Color.fromRGBO(92, 182, 50, 1),
      Color.fromRGBO(60, 153, 225, 1),
      Color.fromRGBO(252, 183, 14, 1),
      Color.fromRGBO(123, 67, 183, 1),
      Color.fromRGBO(253, 151, 54, 1),
      Color.fromRGBO(45, 197, 197, 1),
    ];

    //  {
    //    교시(int): {color:"", subject:""}
    //  },
    @override
    void initState() {
      super.initState();
    }

    void setSubject(String day, int idx) {
      cellList[day]['$idx'] = {
        "color": widget.subjectValue,
        "subject": subjectList[widget.subjectValue]
      };
    }

    void deleteSubject(String day, int idx) {
      setState(() {
        if (cellList[day]['$idx'] != null) {
          cellList[day]['$idx'] = null;
        }
        widget.cellMap = cellList;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          // Days of the week
          Positioned(
            top: 0,
            left: 0,
            child: Row(
              children: [
                _buildCell('', width: cellWidth / 4 - 1, height: cellHeight),
                for (String day in daysOfWeek)
                  _buildCell(day,
                      width: day == "Mon" ? cellWidth + 1 : cellWidth,
                      height: cellHeight,
                      hasBorder: true),
              ],
            ),
          ),
          // Time slots with buttons
          Positioned(
            top: cellHeight,
            left: 0,
            child: Column(
              children: [
                for (int i = 1; i <= 9; i++)
                  Row(
                    children: [
                      _buildCell('$i',
                          width: cellWidth / 4, height: cellHeight),
                      for (String day in daysOfWeek)
                        _buildEmptyCellWithButton(
                          text: cellList[day]['$i'] != null
                              ? cellList[day]['$i']['subject']
                              : "",
                          id: '$day$i',
                          width: cellWidth,
                          height: cellHeight,
                          bgColor: cellList[day]['$i'] != null
                              ? colorList[cellList[day]['$i']['color']]
                              : Colors.white,
                          onPressed: () {
                            if (cellList[day]['$i'] != null &&
                                cellList[day]['$i']['color'] ==
                                    widget.subjectValue) {
                              // 값이 같을 때만 삭제 수행
                              deleteSubject(day, i);
                            } else {
                              setSubject(day, i);
                            }

                            setState(() {
                              cellList = cellList;
                              widget.cellMap = cellList;
                            });
                          },
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text,
      {double? width, double? height, bool hasBorder = false}) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: hasBorder
            ? text == "Mon"
                ? Border.all()
                : Border(
                    right: BorderSide(),
                    top: BorderSide(),
                    bottom: BorderSide(),
                  )
            : text == ""
                ? null
                : Border(
                    right: BorderSide(),
                  ),
        borderRadius: text == "Mon"
            ? BorderRadius.only(topLeft: Radius.circular(5.0))
            : text == "Fri"
                ? BorderRadius.only(topRight: Radius.circular(5.0))
                : BorderRadius.zero,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildEmptyCellWithButton(
      {required String id,
      double? width,
      double? height,
      String text = "",
      Color? bgColor,
      required VoidCallback onPressed}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(),
          right: BorderSide(),
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(bgColor),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 12.5,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Color _generateRandomColor() {
  //   final Random random = Random();
  //   return Color.fromRGBO(
  //     random.nextInt(255),
  //     random.nextInt(255),
  //     random.nextInt(255),
  //     .5,
  //   );
  // }
}
