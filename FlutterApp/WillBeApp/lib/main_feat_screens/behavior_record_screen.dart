import 'package:flutter/material.dart';

class BehaviorRecordScreen extends StatefulWidget {
  const BehaviorRecordScreen({super.key});

  @override
  State<BehaviorRecordScreen> createState() => _BehaviorRecordScreenState();
}

class _BehaviorRecordScreenState extends State<BehaviorRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "행동 기록",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      height: 1500,
                      color: Colors.black,
                    ),
                    Container(
                      width: 300,
                      height: 1500,
                      color: Colors.green,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
