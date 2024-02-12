import 'package:flutter/material.dart';

class CalendarManageScreen extends StatefulWidget {
  const CalendarManageScreen({super.key});

  @override
  State<CalendarManageScreen> createState() => _CalendarManageScreenState();
}

class _CalendarManageScreenState extends State<CalendarManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '일정 관리',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [],
              ),
            ),
          )
        ],
      ),
    );
  }
}
