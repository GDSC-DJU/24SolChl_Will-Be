import 'package:flutter/material.dart';
import 'package:solution/calender_screens/timetable.dart';

class SetRoutinePage extends StatefulWidget {
  const SetRoutinePage({super.key});

  @override
  State<SetRoutinePage> createState() => _SetRoutinePageState();
}

class _SetRoutinePageState extends State<SetRoutinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(
        child: SingleChildScrollView(
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
                  '시간표',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 16,
                height: MediaQuery.sizeOf(context).height / 1.5,
                child: Container(
                  child: Timetable(),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
