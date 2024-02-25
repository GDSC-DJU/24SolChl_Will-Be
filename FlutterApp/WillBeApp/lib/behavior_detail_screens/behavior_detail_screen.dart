import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution/main_feat_screens/main_page.dart';

class Behavior_Detail_Screen extends StatefulWidget {
  Behavior_Detail_Screen(
      {Key? key,
      required this.id,
      required this.name,
      required this.behaviorName,
      required this.iconColor,
      required this.value});
  Color iconColor;
  final String name;
  final String id;
  final String behaviorName;
  dynamic value;
  @override
  State<Behavior_Detail_Screen> createState() => _Behavior_Detail_Screen();
}

class _Behavior_Detail_Screen extends State<Behavior_Detail_Screen> {
  User? _user = FirebaseAuth.instance.currentUser;

  Future<void> doneSetting() async {
    // Record 컬렉션 내 Archive
    DocumentReference targetRef = await FirebaseFirestore.instance
        .collection('Record')
        .doc(widget.id)
        .collection('Behavior')
        .doc(widget.behaviorName);

    dynamic temp = await targetRef.get().then((value) => value.data());
    await targetRef.set({
      "method": temp['method'],
      "behavior": textControllers['behavior']!.text,
      "meaning": textControllers['meaning']!.text,
      "solution": textControllers['solution']!.text,
      "done": "",
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Main_Page(),
      ),
      (route) => false,
    );
  }

  void _stopRecord() async {
    print([
      textControllers['behavior']!.text,
      textControllers['meaning']!.text,
      textControllers['solution']!.text,
    ]);
    if (textControllers['behavior']!.text == "" ||
        textControllers['meaning']!.text == "" ||
        textControllers['solution']!.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('모두 입력한 후 측정을 종료해주세요!')));
      return;
    } else {
      return showDialog<void>(
        //다이얼로그 위젯 소환
        context: context,
        barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: SizedBox(
              height: 30,
              child: Image.asset(
                'assets/icons/willbe.png',
                fit: BoxFit.contain,
              ),
            ),
            content: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: const Text(
                    '행동 측정을 중단할까요?',
                    textAlign: TextAlign.center,
                  )),
            ),
            actions: [
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 22, 72, 99),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(4.0),
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () async {
                        //firestore에 관련된 인스턴스들
                        User? user = FirebaseAuth.instance.currentUser;
                        doneSetting();
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
    // 알림창 띄우기 -> 확인 버튼 누르면 DB에 객체 생성
  }

  @override
  void initState() {
    super.initState();

    // getBehaviorList(widget.studentIdList);
    textControllers["behavior"]!.text =
        widget.value['behavior'] != null ? widget.value['behavior'] : '';
    textControllers["meaning"]!.text =
        widget.value['meaning'] != null ? widget.value['meaning'] : '';
    textControllers["solution"]!.text =
        widget.value['solution'] != null ? widget.value['solution'] : '';
  }

  Map<String, TextEditingController> textControllers = {
    "behavior": TextEditingController(),
    "meaning": TextEditingController(),
    "solution": TextEditingController(),
  };

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 버튼을 눌렀을 때 수행할 동작을 정의
        bool shouldPop = await _showExitConfirmationDialog(context);
        return shouldPop;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              "행동 별 자세한 기록",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 0,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                            ),
                            child: Icon(
                              Icons.person,
                              color: widget.iconColor,
                              size: 30,
                            ),
                            // Image.network(
                            //   "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Text(
                                widget.behaviorName,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Colors.black26,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: MediaQuery.of(context).size.height - 172,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                            "보이는 행동", textControllers["behavior"], 0),
                        _buildTextField(
                            "행동의 의미(기능분석)", textControllers["meaning"], 1),
                        _buildTextField("대처법", textControllers["solution"], 2),
                        Center(
                          child: SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                _stopRecord();
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.white,
                              ),
                              child: Container(
                                width: double.infinity,
                                color: Colors.white70,
                                child: Center(
                                  child: Text(
                                    '이 행동 측정 그만하기',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 350,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController? controller, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(label),
        ),
        TextFormField(
          controller: controller,
          maxLines: null,
          style: TextStyle(fontSize: 15),
          onTap: () => _scrollToField(controller, index),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Color.fromARGB(255, 102, 108, 255)),
            ),
            hintText: "입력하세요",
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void _scrollToField(TextEditingController? controller, int index) {
    if (controller != null) {
      _scrollController.animateTo(
        index * 150,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: SizedBox(
              height: 30,
              child: Image.asset(
                'assets/icons/willbe.png',
                fit: BoxFit.contain,
              ),
            ),
            content: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: const Text(
                    '행동 별 자세한 기록을 완료할까요?',
                    textAlign: TextAlign.center,
                  )),
            ),
            actions: [
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Main_Page(),
                    ),
                    (route) => false,
                  );
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 102, 108, 255),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(4.0),
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () async {
                        if (_user != null) {
                          DocumentReference behaviorRef = FirebaseFirestore
                              .instance
                              .collection('Record')
                              .doc(widget.id)
                              .collection('Behavior')
                              .doc(widget.behaviorName);

                          behaviorRef.get().then((value) {
                            dynamic temp = value.data();
                            temp['behavior'] =
                                textControllers['behavior']!.text;
                            temp['meaning'] = textControllers['meaning']!.text;
                            temp['solution'] =
                                textControllers['solution']!.text;

                            behaviorRef.set(temp);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Main_Page(),
                              ),
                              (route) => false,
                            );
                          });
                        }
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
