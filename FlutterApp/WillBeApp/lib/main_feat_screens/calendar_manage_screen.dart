import 'package:flutter/material.dart';
import 'package:solution/calender_screens/timetable_example.dart';
import 'package:solution/calender_screens/timetable.dart';

class CalendarManageScreen extends StatefulWidget {
  const CalendarManageScreen({super.key});

  @override
  State<CalendarManageScreen> createState() => _CalendarManageScreenState();
}

class _CalendarManageScreenState extends State<CalendarManageScreen> {
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
                '시간표',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width - 16,
              height: MediaQuery.sizeOf(context).height / 2,
              child: Container(
                child: Timetable(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
