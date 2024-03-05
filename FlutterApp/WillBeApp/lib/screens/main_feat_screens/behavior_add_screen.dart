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

  String? behaviorName;
  String? behaviorType;
  String? behavior;
  String? measurementUnit;
  String? estimationFunction;
  String? particulars;

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
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
                      style: Theme.of(context).textTheme.bodyLarge,
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
                Text(
                  "행동명",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    behaviorName = value;
                  },
                ),
                Text(
                  "행동유형",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    behaviorType = value;
                  },
                ),
                Text(
                  "측정단위",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    measurementUnit = value;
                  },
                ),
                Text(
                  "추정기능",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    estimationFunction = value;
                  },
                ),
                Text(
                  "특이사항",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    particulars = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          print("행동 추가 버튼 동작 시작");
                          print(nameForDropdown);

                          print(behaviorName);
                          print(behaviorType);
                          print(measurementUnit);
                          print(estimationFunction);
                          print(particulars);
                        },
                        child: Text(
                          "행동 추가",
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
