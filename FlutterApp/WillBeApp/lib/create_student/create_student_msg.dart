import 'package:flutter/material.dart';
import 'package:solution/create_student/add_student_info.dart';

class Create_student_Msg extends StatefulWidget {
  Create_student_Msg({
    super.key,
  });

  String? name = "";
  String school = "";
  int? schoolValue;

  @override
  State<Create_student_Msg> createState() => _Create_student_Msg_State();
}

class _Create_student_Msg_State extends State<Create_student_Msg> {
  void _submitData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Add_Student_Info(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          SizedBox(
                            width: 150,
                            child: Image.asset(
                              'assets/icons/appicon/willbe-icon-darker.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Text(
                            "Will Be",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const Text(
                            "서비스를 이용하기 위해서는\n\n아이와 아이의 도전행동을 등록해야해요\n\n루틴을 등록하면\n해당시간대의 환경이\n자동으로 기록돼요\n\n기록하고 리포트를 받아보세요\n\n의사소통사전을 통해\n아이가 무엇을 표현하고자 하는지\n알아보세요",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _submitData();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        color: const Color.fromARGB(255, 22, 72, 99),
                        child: const Center(
                          child: Text(
                            '시작하기',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
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
