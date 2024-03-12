import 'package:flutter/material.dart';
import 'package:solution/assets/pallet.dart';

class Timetable extends StatefulWidget {
  Timetable({
    Key? key,
    required this.subjectValue,
    required this.changeSubject,
    required this.subjectList,
    this.cellMap,
  }) : super(key: key);
  Map? cellMap;
  final int subjectValue;
  final Function(int) changeSubject;
  final List subjectList;

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
              "subject": widget.subjectList[widget.subjectValue],
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

    List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    // 과목 색 class
    SubjectColors subjectColors = SubjectColors();

    @override
    void initState() {
      super.initState();
    }

    void setSubject(String day, int idx) {
      cellList[day]['$idx'] = {
        "color": widget.subjectValue,
        "subject": widget.subjectList[widget.subjectValue]
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
                              ? subjectColors.subjectColorList[cellList[day]
                                  ['$i']['color']]
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
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: hasBorder
            ? text == "Mon"
                ? Border.all()
                : const Border(
                    right: BorderSide(),
                    top: BorderSide(),
                    bottom: BorderSide(),
                  )
            : text == ""
                ? null
                : const Border(
                    right: BorderSide(),
                  ),
        borderRadius: text == "Mon"
            ? const BorderRadius.only(topLeft: Radius.circular(5.0))
            : text == "Fri"
                ? const BorderRadius.only(topRight: Radius.circular(5.0))
                : BorderRadius.zero,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
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
      decoration: const BoxDecoration(
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
            style: const TextStyle(
                fontSize: 12.5,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
