import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:solution/main_feat_screens/main_page.dart';

class Daily_Report_List_Screen extends StatefulWidget {
  Daily_Report_List_Screen(
      {Key? key,
      required this.name,
      required this.id,
      required this.iconColor,
      required this.reportList});
  final String name;
  final String id;
  dynamic reportList;
  Color iconColor;
  @override
  State<Daily_Report_List_Screen> createState() =>
      _Daily_Report_List_Screen_State();
}

User? _user = FirebaseAuth.instance.currentUser;

class _Daily_Report_List_Screen_State extends State<Daily_Report_List_Screen> {
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
    "behavior": TextEditingController(),
    "meaning": TextEditingController(),
  };
  @override
  void initState() {
    super.initState();
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
            "일일리포트",
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
                    itemCount: widget.reportList.length,
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
                                  '${widget.reportList[index].keys.toList()[0]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.sizeOf(context).width *
                                              0.055,
                                      color: Colors.black),
                                ),
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
                                                ...widget
                                                    .reportList[index].values
                                                    .toList()[0]
                                                    .values
                                                    .toList()
                                                    .asMap()
                                                    .entries
                                                    .map((item) => Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '${widget.reportList[index].values.toList()[0].keys.toList()[item.key]}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          22,
                                                                          72,
                                                                          99))),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                '상황',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          96,
                                                                          162,
                                                                          198),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${item.value['situation']}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                '결과',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          96,
                                                                          162,
                                                                          198),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${item.value['action']}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                '특이사항',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          96,
                                                                          162,
                                                                          198),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${item.value['etc']}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  height: 3,
                                                                  color: Colors
                                                                      .black12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                    .toList(),
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
