import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:solution/main_feat_screens/main_page.dart';

class History_Screen extends StatefulWidget {
  History_Screen(
      {Key? key,
      required this.name,
      required this.id,
      required this.iconColor,
      required this.historyList});
  final String name;
  final String id;
  dynamic historyList;
  Color iconColor;
  @override
  State<History_Screen> createState() => _History_Screen_State();
}

User? _user = FirebaseAuth.instance.currentUser;

class _History_Screen_State extends State<History_Screen> {
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
    "behavior": TextEditingController(),
    "meaning": TextEditingController(),
  };
  @override
  void initState() {
    super.initState();
    print("intinetet");
    print(widget.historyList);
    // getBehaviorList(widget.studentIdList);
  }

  @override
  Widget build(BuildContext context) {
    // widget.name = textControllers["name"]?.text;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "과거기록보기",
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
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: widget.iconColor, width: 3),
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
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 1,
                color: Colors.black26,
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width - 12,
                  height: MediaQuery.sizeOf(context).height / 1.27,
                  child:
                      // 과거기록 builder
                      ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: widget.historyList.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.sizeOf(context).width - 12,
                        child: Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Row(
                              children: [
                                Text(
                                  '${widget.historyList[index].keys.toList()[0]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.sizeOf(context).width *
                                              0.045,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            initiallyExpanded: false,
                            backgroundColor: Colors.white,
                            children: <Widget>[
                              SingleChildScrollView(
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width - 12,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 236, 236, 236),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.02 *
                                                  45.2,
                                          //textController 반복 생성
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  // '${widget.dictList[widget.dictList.keys.toList()[index]]['direction']}',
                                                  '보이는 행동',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromRGBO(
                                                          22, 72, 99, 1)),
                                                ),
                                                Text(
                                                  // '${widget.dictList[widget.dictList.keys.toList()[index]]['meaning']}',
                                                  '${widget.historyList[index][widget.historyList[index].keys.toList()[0]]['behavior']}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                Text(
                                                  // '${widget.dictList[widget.dictList.keys.toList()[index]]['direction']}',
                                                  '행동의 의미',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromRGBO(
                                                          22, 72, 99, 1)),
                                                ),
                                                Text(
                                                  // '${widget.dictList[widget.dictList.keys.toList()[index]]['direction']}',
                                                  '${widget.historyList[index][widget.historyList[index].keys.toList()[0]]['meaning']}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                Text(
                                                  // '${widget.dictList[widget.dictList.keys.toList()[index]]['direction']}',
                                                  '대처법',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromRGBO(
                                                          22, 72, 99, 1)),
                                                ),
                                                Text(
                                                  // '${widget.dictList[widget.dictList.keys.toList()[index]]['direction']}',
                                                  '${widget.historyList[index][widget.historyList[index].keys.toList()[0]]['solution']}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
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
