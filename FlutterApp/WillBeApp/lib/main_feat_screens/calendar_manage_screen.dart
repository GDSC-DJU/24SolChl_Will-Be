import 'package:flutter/material.dart';
import 'package:solution/calender_screens/timetable_example.dart';
import 'package:solution/calender_screens/set_routine_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarManageScreen extends StatefulWidget {
  CalendarManageScreen({super.key, required this.cellMap});
  Map<String, dynamic> cellMap;

  @override
  State<CalendarManageScreen> createState() => _CalendarManageScreenState();
}

class _CalendarManageScreenState extends State<CalendarManageScreen> {
  User? _user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    print("intinetet");
    print(widget.cellMap);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).height - 16,
              child: Text(
                '일정관리',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // DocumentReference timetableRef = FirebaseFirestore.instance
                    //     .collection('Educator')
                    //     .doc(_user!.uid)
                    //     .collection('Schedule')
                    //     .doc('Timetable');
                    // timetableRef.get().then((value) {
                    //   dynamic tCellMap = value.data();
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           SetRoutinePage(cellMap: tCellMap),
                    //     ),
                    //   );
                    // });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SetRoutinePage(cellMap: widget.cellMap),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.zero,
                    backgroundColor: Color.fromARGB(255, 102, 108, 255),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text(
                        '루틴 설정하기',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width - 16,
              height: MediaQuery.sizeOf(context).height - 220,
              child: Container(
                child: TimeTableCalendar(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
