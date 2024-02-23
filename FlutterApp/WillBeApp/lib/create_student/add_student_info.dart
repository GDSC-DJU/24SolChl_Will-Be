import 'package:flutter/material.dart';
import 'package:solution/create_student/add_behavior.dart';

class Add_Student_Info extends StatefulWidget {
  Add_Student_Info({Key? key});

  String? name = "";
  String school = "";
  int? schoolValue;

  @override
  State<Add_Student_Info> createState() => _Add_Student_Info_State();
}

class _Add_Student_Info_State extends State<Add_Student_Info> {
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
  };
  // List schoolList = ["유치원", "초등학교", "중학교", "고등학교"];

  // int expValue = 1; // 추가된 부분
  // List expMsgList = [
  //   "1.~~",
  //   "2.~~",
  //   "3.~~",
  //   "4.~~",
  //   "5.~~",
  // ];
  // List selfHelpMsgList = [
  //   "1.~~",
  //   "2.~~",
  //   "3.~~",
  //   "4.~~",
  //   "5.~~",
  // ];

  // int selfHelpValue = 1; // 추가된 부분

  void _submitData() {
    if (widget.name == ""
        // || widget.schoolValue == null
        ) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('모든 항목을 입력해주세요!')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Add_Behavior(
          name: widget.name,
          // schoolValue: widget.schoolValue,
          // expValue: expValue.toInt(), // 수정된 부분
          // selfHelpValue: selfHelpValue.toInt(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.name = textControllers["name"]?.text;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Container(
          height: MediaQuery.of(context).size.height,
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
                      color: Color.fromARGB(255, 22, 72, 99),
                      fontWeight: FontWeight.w500,
                      fontSize: 23,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: '아이 이름',
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: -20, bottom: 4),
                    focusColor: Color.fromARGB(255, 22, 72, 99),
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
              // SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width - 32,
              //     padding: EdgeInsets.only(
              //       top: 16,
              //       bottom: 8,
              //     ),
              //     child: Text(
              //       "학령 선택",
              //       textAlign: TextAlign.left,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //         color: Color.fromARGB(255, 22, 72, 99),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Row(
              //     children: [
              //       CustomRadioButton(
              //         isSelected: widget.schoolValue == 0,
              //         onTap: () {
              //           setState(() {
              //             widget.schoolValue = 0;
              //           });
              //         },
              //         text: '유치원',
              //       ),
              //       SizedBox(width: 14),
              //       CustomRadioButton(
              //         isSelected: widget.schoolValue == 1,
              //         onTap: () {
              //           setState(() {
              //             widget.schoolValue = 1;
              //           });
              //         },
              //         text: '초등학교',
              //       ),
              //       SizedBox(width: 14),
              //       CustomRadioButton(
              //         isSelected: widget.schoolValue == 2,
              //         onTap: () {
              //           setState(() {
              //             widget.schoolValue = 2;
              //           });
              //         },
              //         text: '중학교',
              //       ),
              //       SizedBox(width: 14),
              //       CustomRadioButton(
              //         isSelected: widget.schoolValue == 3,
              //         onTap: () {
              //           setState(() {
              //             widget.schoolValue = 3;
              //           });
              //         },
              //         text: '고등학교',
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width - 32,
              //     padding: EdgeInsets.only(
              //       top: 16,
              //       bottom: 8,
              //     ),
              //     child: Text(
              //       "의사소통 수준",
              //       textAlign: TextAlign.left,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //         color: Color.fromARGB(255, 22, 72, 99),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width - 32,
              //     padding: EdgeInsets.only(
              //       top: 16,
              //       bottom: 8,
              //     ),
              //     child: Text(
              //       expMsgList[expValue - 1],
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: SliderTheme(
              //     data: SliderThemeData(
              //       thumbColor: Color.fromARGB(255, 22, 72, 99),
              //       thumbShape: AppSliderShape(
              //           thumbRadius: 10, thumbValue: expValue.toString()),
              //     ),
              //     child: Slider(
              //       value: expValue?.toDouble() ?? 1.0,
              //       onChanged: (value) {
              //         setState(() {
              //           expValue = value.toInt();
              //         });
              //       },
              //       min: 1.0,
              //       max: 5.0,
              //       divisions: 4,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width - 32,
              //     padding: EdgeInsets.only(
              //       top: 16,
              //       bottom: 8,
              //     ),
              //     child: Text(
              //       "자조기술 수준",
              //       textAlign: TextAlign.left,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //         color: Color.fromARGB(255, 22, 72, 99),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width - 32,
              //     padding: EdgeInsets.only(
              //       top: 16,
              //       bottom: 8,
              //     ),
              //     child: Text(
              //       selfHelpMsgList[selfHelpValue - 1],
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: SliderTheme(
              //     data: SliderThemeData(
              //       thumbColor: Color.fromARGB(255, 22, 72, 99),
              //       thumbShape: AppSliderShape(
              //           thumbRadius: 10, thumbValue: selfHelpValue.toString()),
              //     ),
              //     child: Slider(
              //       value: selfHelpValue?.toDouble() ?? 1.0,
              //       onChanged: (value) {
              //         setState(() {
              //           selfHelpValue = value.toInt();
              //         });
              //       },
              //       min: 1.0,
              //       max: 5.0,
              //       divisions: 4,
              //     ),
              //   ),
              // ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _submitData();
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
                  color: Color.fromARGB(255, 22, 72, 99),
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
          color: isSelected ? Color.fromARGB(255, 22, 72, 99) : Colors.black12,
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

class AppSliderShape extends SliderComponentShape {
  final double thumbRadius;
  final String thumbValue;

  const AppSliderShape({required this.thumbRadius, required this.thumbValue});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      text: thumbValue,
    );

    TextPainter textPainter = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    Offset textCenter = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    canvas.drawCircle(
      center,
      20,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Color.fromARGB(255, 22, 72, 99),
    );
    canvas.drawCircle(
      center,
      15,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white,
    );
    textPainter.paint(canvas, textCenter);
  }
}
