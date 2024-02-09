import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solution/tutorial/tutorial_behavior_select.dart';

class Tutorial_Student_Create extends StatefulWidget {
  Tutorial_Student_Create({Key? key});

  var name = "";
  String school = "";
  int? schoolValue; // Nullable로 변경

  @override
  State<Tutorial_Student_Create> createState() =>
      _Tutorial_Student_Create_State();
}

class _Tutorial_Student_Create_State extends State<Tutorial_Student_Create> {
  // 입력값을 추적하기 위한 controllers
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 40,
                  ),
                  child: Text(
                    "아이를 등록해볼까요?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    floatingLabelStyle: TextStyle(
                      color: Color.fromARGB(255, 102, 108, 255),
                      fontWeight: FontWeight.w500,
                      fontSize: 23,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: '아이 이름',
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: -20, bottom: 4),
                    focusColor: Color.fromARGB(255, 102, 108, 255),
                    labelStyle: TextStyle(
                      fontSize: 25,
                      color: Colors.black26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controller: textControllers["name"],
                  onChanged: (value) {
                    setState(() {
                      widget.name = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    "학령 선택",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 102, 108, 255),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CustomRadioButton(
                      isSelected: widget.schoolValue == 0,
                      onTap: () {
                        setState(() {
                          widget.schoolValue = 0;
                        });
                      },
                      text: '유치원',
                    ),
                    SizedBox(width: 14),
                    CustomRadioButton(
                      isSelected: widget.schoolValue == 1,
                      onTap: () {
                        setState(() {
                          widget.schoolValue = 1;
                        });
                      },
                      text: '초등학교',
                    ),
                    SizedBox(width: 14),
                    CustomRadioButton(
                      isSelected: widget.schoolValue == 2,
                      onTap: () {
                        setState(() {
                          widget.schoolValue = 2;
                        });
                      },
                      text: '중학교',
                    ),
                    SizedBox(width: 14),
                    CustomRadioButton(
                      isSelected: widget.schoolValue == 3,
                      onTap: () {
                        setState(() {
                          widget.schoolValue = 3;
                        });
                      },
                      text: '고등학교',
                    ),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Tutorial_Behavior_Select(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 32),
                  color: Color.fromARGB(255, 102, 108, 255),
                  child: Center(
                    child: Text(
                      '다음',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String text;

  CustomRadioButton({
    required this.isSelected,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color:
              isSelected ? Color.fromARGB(255, 102, 108, 255) : Colors.black12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
