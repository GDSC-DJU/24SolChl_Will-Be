import 'package:flutter/material.dart';
import 'package:solution/dictionary_screens/expression_dictionary_create.dart';
import 'package:solution/dictionary_screens/expression_dictionary_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:solution/main_feat_screens/main_page.dart';

class Expression_Dictionary extends StatefulWidget {
  Expression_Dictionary(
      {Key? key,
      required this.name,
      required this.id,
      required this.iconColor,
      required this.dictList});
  final String name;
  final String id;
  dynamic dictList;
  Color iconColor;
  @override
  State<Expression_Dictionary> createState() => _Expression_Dictionary_State();
}

User? _user = FirebaseAuth.instance.currentUser;

class _Expression_Dictionary_State extends State<Expression_Dictionary> {
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
    "behavior": TextEditingController(),
    "meaning": TextEditingController(),
  };
  @override
  void initState() {
    super.initState();
    print("intinetet");
    print(widget.dictList);
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
            "의사소통사전",
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
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Expression_Dictionary_Create(
                                name: widget.name,
                                id: widget.id,
                                iconColor: widget.iconColor,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                        ),
                        child: Container(
                          width: 190,
                          height: 35,
                          child: Center(
                            child: Text(
                              '+ 의사소통사전 추가하기',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SizedBox(
                      width: 110,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Record 컬렉션 내 Report 세팅 (Daily)
                          await FirebaseFirestore.instance
                              .collection('Record')
                              .doc(widget.id)
                              .collection('Report')
                              .doc(_user!.uid)
                              .collection("Daily")
                              .doc('0000-00-00')
                              .set({});
                          DateTime MonDay = DateTime.now().subtract(
                              Duration(days: DateTime.now().weekday - 1));
                          DateTime FriDay = DateTime.now().subtract(
                              Duration(days: DateTime.now().weekday - 5));
                          // Record 컬렉션 내 Report 세팅 (Weekly)
                          await FirebaseFirestore.instance
                              .collection('Record')
                              .doc(widget.id)
                              .collection('Report')
                              .doc(_user!.uid)
                              .collection("Weekly")
                              .doc(
                                  '${MonDay.year}-${MonDay.month}-${MonDay.day}_${FriDay.year}-${FriDay.month}-${FriDay.day}')
                              .set({});

                          await FirebaseFirestore.instance
                              .collection('Student')
                              .doc(widget.id)
                              .collection('Dictionary')
                              .doc('expression')
                              .set({});
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.ios_share,
                              color: Colors.black,
                              size: 20,
                            ),
                            Container(
                              // width: 80,
                              height: 35,
                              child: Center(
                                child: Text(
                                  '공유하기',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
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
              SizedBox(
                height: 16,
              ),
              Container(
                height: 1,
                color: Colors.black26,
              ),
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 12,
                  height: MediaQuery.sizeOf(context).height / 1.365,
                  child:
                      // 의사소통 builder
                      ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: widget.dictList.keys.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.sizeOf(context).width - 12,
                        child: Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Row(
                              children: [
                                Text(
                                  '${widget.dictList.keys.toList()[index]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.sizeOf(context).width *
                                              0.045,
                                      color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Expression_Dictionary_Edit(
                                          name: widget.name,
                                          id: widget.id,
                                          iconColor: widget.iconColor,
                                          behavior: widget.dictList.keys
                                              .toList()[index],
                                          meaning: widget.dictList[widget
                                              .dictList.keys
                                              .toList()[index]]['meaning'],
                                          direction: widget.dictList[widget
                                              .dictList.keys
                                              .toList()[index]]['direction'],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                )
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            initiallyExpanded: false,
                            backgroundColor: Colors.white,
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Container(
                                  // height: 200,
                                  width: MediaQuery.sizeOf(context).width - 12,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
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
                                                  '${widget.dictList[widget.dictList.keys.toList()[index]]['meaning']}',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                Text(
                                                  '${widget.dictList[widget.dictList.keys.toList()[index]]['direction']}',
                                                  style:
                                                      TextStyle(fontSize: 16),
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
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //   ],
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget _buildTextField(
//     String label, TextEditingController? controller, int index) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       TextFormField(
//         controller: controller,
//         maxLines: null,
//         readOnly: true,
//         style: TextStyle(fontSize: 15),
//         decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide(),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide(color: Colors.blue),
//             ),
//             hintText:
//                 '${widget.dictList[widget.dictList.keys.toList()[index]]}',
//             hintStyle: TextStyle(color: Black)),
//       ),
//       SizedBox(
//         height: 20,
//       ),
//     ],
//   );
// }
