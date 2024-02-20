import 'package:flutter/material.dart';
import 'package:solution/calender_screens/timetable_example.dart';
import 'package:solution/calender_screens/set_routine_page.dart';

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetRoutinePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.zero,
                    backgroundColor: const Color.fromARGB(255, 102, 108, 255),
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
                child: const TimeTableCalendar(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
