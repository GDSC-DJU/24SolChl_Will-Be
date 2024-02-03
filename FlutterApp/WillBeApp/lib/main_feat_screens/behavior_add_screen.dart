import 'package:flutter/material.dart';

class BehaviorAddScreen extends StatefulWidget {
  BehaviorAddScreen({super.key, required this.studentDataList});
  List<dynamic> studentDataList;

  @override
  State<BehaviorAddScreen> createState() => _BehaviorAddScreenState();
}

class _BehaviorAddScreenState extends State<BehaviorAddScreen> {
  List<String> studentsName = [];
  String nameForDropdown = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var studentData in widget.studentDataList) {
      if (studentData is Map<String, dynamic>) {
        String name = studentData['name'];
        studentsName.add(name);
      }
    }
    nameForDropdown = studentsName.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                    Text(
                      '행동 추가',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Text(
                  "행동 주체",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                DropdownButton(
                  value: nameForDropdown ?? studentsName.first,
                  style: Theme.of(context).textTheme.bodyMedium,
                  items: studentsName.map((name) {
                    return (DropdownMenuItem(
                      value: name,
                      child: Text(name),
                    ));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      nameForDropdown = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("data")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
