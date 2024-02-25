import 'package:flutter/material.dart';
import 'package:solution/calender_screens/timetable_calendar.dart';
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
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
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
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SetRoutinePage(cellMap: widget.cellMap),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color.fromARGB(255, 22, 72, 99),
                    ),
                    child: const SizedBox(
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
                  child: TimeTableCalendar(cellMap: widget.cellMap),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
