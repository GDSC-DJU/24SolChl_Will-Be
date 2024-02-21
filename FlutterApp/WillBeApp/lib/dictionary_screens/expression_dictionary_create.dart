import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solution/dictionary_screens/expression_dictoinary.dart';
import 'package:solution/main_feat_screens/main_page.dart';

class Expression_Dictionary_Create extends StatefulWidget {
  Expression_Dictionary_Create({
    Key? key,
    required this.name,
    required this.id,
    required this.iconColor,
  });
  Color iconColor;
  final String name;
  final String id;
  String behavior = "";
  String meaning = "";
  String direction = "";
  @override
  State<Expression_Dictionary_Create> createState() =>
      _Expression_Dictionary_Create_State();
}

User? _user = FirebaseAuth.instance.currentUser;

class _Expression_Dictionary_Create_State
    extends State<Expression_Dictionary_Create> {
  Map<String, TextEditingController> textControllers = {
    "behavior": TextEditingController(),
    "meaning": TextEditingController(),
    "direction": TextEditingController(),
  };
  void _submitData() {
    if (textControllers["behavior"]!.text == "" ||
        textControllers["meaning"]!.text == "" ||
        textControllers["direction"]!.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('모든 항목을 입력해주세요!')));
      return;
    }
    DocumentReference dictRef = FirebaseFirestore.instance
        .collection('Student')
        .doc(widget.id)
        .collection('Dictionary')
        .doc('expression');

    dictRef.get().then((value) {
      dynamic temp = value.data();
      temp[textControllers['behavior']!.text] = {
        'meaning': textControllers['meaning']!.text,
        'direction': textControllers['direction']!.text,
      };

      dictRef.set(temp);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('저장 완료!')));
    });
  }

  @override
  Widget build(BuildContext context) {
    // widget.name = textControllers["name"]?.text;
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
              "의사소통사전 추가하기",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Container(
            // height: MediaQuery.of(context).size.height,
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
                            //   // 이미지 DB 구축 시 대치
                            //   "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 30),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _submitData();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.zero,
                            backgroundColor:
                                const Color.fromARGB(255, 246, 100, 92),
                          ),
                          child: SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 0.025 * 8.5,
                            height:
                                MediaQuery.of(context).size.height * 0.01 * 5,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                Text(
                                  " 저장",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
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
                  width: MediaQuery.sizeOf(context).width - 32,
                  height: MediaQuery.sizeOf(context).height - 213,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            maxLength: 15,
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              helperText: "아이가 하는 표현이나 행동을 적어주세요.",
                              helperStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(175, 175, 175, 1),
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Color.fromARGB(255, 102, 108, 255),
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelText: '표현(행동)',
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.only(top: -20, bottom: 4),
                              focusColor: Color.fromARGB(255, 102, 108, 255),
                              labelStyle: TextStyle(
                                fontSize: 25,
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: textControllers["behavior"],
                            onChanged: (value) {
                              setState(() {
                                widget.behavior = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            maxLength: 20,
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              helperText: "아이가 표현을 통해 말하고자하는 의미를 적어주세요.",
                              helperStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(175, 175, 175, 1),
                              ),
                              border: UnderlineInputBorder(),
                              floatingLabelStyle: TextStyle(
                                color: Color.fromARGB(255, 102, 108, 255),
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelText: '표현의 의미',
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.only(top: -20, bottom: 4),
                              focusColor: Color.fromARGB(255, 102, 108, 255),
                              labelStyle: TextStyle(
                                fontSize: 25,
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: textControllers["meaning"],
                            onChanged: (value) {
                              setState(() {
                                widget.meaning = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width - 32,
                                child: Text("이렇게 해주세요"),
                              ),
                              TextFormField(
                                controller: textControllers["direction"],
                                maxLines: null,
                                style: TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 102, 108, 255)),
                                  ),
                                  hintText: "입력하세요",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: MediaQuery.sizeOf(context).width - 32,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "어떻게 대처해야하는지 적어주세요.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(175, 175, 175, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height - 390,
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
                child: Column(
                  children: [
                    Text(
                      '의사소통사전 추가를 완료할까요?',
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        '(저장을 꼭 진행해주세요!)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
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
                        DocumentReference dictRef = FirebaseFirestore.instance
                            .collection('Student')
                            .doc(widget.id)
                            .collection('Dictionary')
                            .doc('expression');
                        dictRef.get().then((value) {
                          dynamic temp = value.data();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Main_Page(),
                            ),
                            (route) => false,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Expression_Dictionary(
                                name: widget.name,
                                id: widget.id,
                                iconColor: widget.iconColor,
                                dictList: temp,
                              ),
                            ),
                          );
                        });
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
