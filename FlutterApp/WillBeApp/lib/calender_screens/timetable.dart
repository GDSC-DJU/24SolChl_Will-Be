///This is open source

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:solution/calender_screens/set_routine_page.dart';

class Timetable extends StatefulWidget {
  Timetable(
      {Key? key, required this.subjectValue, required this.changeSubject});
  final int subjectValue;
  final Function(int) changeSubject;

  // final int subjectValue;
  Map cellList = {
    "Mon": {},
    "Tue": {},
    "Wed": {},
    "Thu": {},
    "Fri": {},
  };
  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  @override
  Widget build(BuildContext context) {
    double cellWidth = (MediaQuery.of(context).size.width - 16) / 6.25;
    double cellHeight = MediaQuery.of(context).size.width / 10;

    List subjectList = ['수학', '체육', '말듣쓰 ', '음악', '실과'];
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
      widget.cellList[day][idx] = {
        "color": widget.subjectValue,
        "subject": subjectList[widget.subjectValue]
      };
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
                            text: widget.cellList[day][i] != null
                                ? widget.cellList[day][i]['subject']
                                : "",
                            id: '$day$i',
                            width: cellWidth,
                            height: cellHeight,
                            bgColor: widget.cellList[day][i] != null
                                ? colorList[widget.cellList[day][i]['color']]
                                : Colors.white,
                            onPressed: () {
                              _showButtonIdSnackBar(
                                  context, '$day$i - ${widget.subjectValue}');
                              setSubject(day, i);

                              setState(() {
                                widget.cellList = widget.cellList;
                              });
                            }),
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
            style: TextStyle(color: Colors.white),
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

  void _showButtonIdSnackBar(BuildContext context, String id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You clicked the button with ID: $id'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
