import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solution/create_student/add_behavior_detail.dart';

class Add_Behavior extends StatefulWidget {
  Add_Behavior({Key? key, required this.name, this.id = ""});
  final String? name;
  String id;
  // final int? schoolValue;
  // int? expValue;
  // int? selfHelpValue;
  int behaviorValue = 0;

  @override
  State<Add_Behavior> createState() => _Add_Behavior_State();
}

class _Add_Behavior_State extends State<Add_Behavior> {
  // 입력값을 추적하기 위한 controllers
  List<String> schoolOptions = [
    '언어적 공격(욕설, 고함)',
    '불순종',
    '과제 이탈',
    '신체적 공격(차기, 꼬집기, 때리기)',
    '기물 파괴',
    '다른 사람을 놀리거나 화나게함',
    '달아나기',
    '안절부절못함',
    '울화 터뜨리기',
    '소리 지르기',
    '기타'
  ];
  void _submitData() {
    if (widget.name == "" ||
        // widget.schoolValue == null ||
        widget.behaviorValue == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('측정할 도전행동의 유형을 선택해주세요!')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Add_Behavior_Detail(
          name: widget.name,
          // schoolValue: widget.schoolValue,
          // expValue: widget.expValue,
          // selfHelpValue: widget.selfHelpValue,
          behaviorValue: widget.behaviorValue,
          id: widget.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.sizeOf(context).height - 80,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 16,
                      ),
                      child: Text(
                        "측정할 도전행동의 유형을\n선택해주세요",
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
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      padding: EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Text(
                        "도전행동의 강도, 빈도, 기간를 고려했을 때\n가장 심각도가 높은 행동을 측정하면 좋아요.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            // spacing: 14,
                            children: [
                              for (int i = 0; i < schoolOptions.length; i++)
                                Container(
                                  margin:
                                      EdgeInsets.only(right: 12, bottom: 10),
                                  child: CustomRadioButton(
                                    isSelected: widget.behaviorValue == i,
                                    onTap: () {
                                      setState(() {
                                        widget.behaviorValue = i;
                                      });
                                    },
                                    text: schoolOptions[i],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
          )),
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
