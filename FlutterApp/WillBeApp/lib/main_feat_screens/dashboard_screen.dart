import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:solution/dictionary_screens/expression_dictoinary.dart';
import 'package:solution/behavior_detail_screens/behavior_detail_screen.dart';

class DashBoardScreen extends StatefulWidget {
  List<dynamic> studentDataList;
  List<dynamic> studentIdList;
  List<dynamic> itemContentList;

  DashBoardScreen(
      {super.key,
      required this.studentDataList,
      required this.studentIdList,
      required this.itemContentList});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01 * 2,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width - 32,
              child: Text(
                '요약',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width - 32,
              height: MediaQuery.sizeOf(context).height - 170,
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: widget.studentDataList.length,
                itemBuilder: (context, index) {
                  return buildSummaryCard(widget.studentDataList[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryCard(Object data, int index) {
    Map<String, dynamic> studentData = (data as Map<String, dynamic>);
    String name = studentData['name'];

    return GestureDetector(
      onTap: () {
        // 탭 시 처리 로직 추가
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.01 * 5,
                      height: MediaQuery.of(context).size.height * 0.01 * 5,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Image.network(
                          // 이미지 DB 구축 시 대치
                          "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        name,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 30),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Expression_Dictionary(
                              name: name,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.zero,
                        backgroundColor: Color.fromARGB(255, 246, 100, 92),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.025 * 10.5,
                        height: MediaQuery.of(context).size.height * 0.01 * 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.book,
                              color: Colors.white,
                              size: 15,
                            ),
                            Text(
                              " 의사소통사전",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01 * 1.6),
              Container(
                height: MediaQuery.of(context).size.height * 0.01 * 30,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(child: Text("그래프")),
              ),
              // 필요한 정보들을 추가
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "데일리 리포트",
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.01 * 10,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(child: Text("리포트 슬라이드")),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "주간 리포트",
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.01 * 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // DB로 받은 리포트 수
                    itemCount: 10,
                    itemBuilder: (BuildContext ctx, int idx) {
                      return Container(
                        margin: EdgeInsets.only(right: 12),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Expression_Dictionary(
                                  name: name,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.black12,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.025 *
                                10.5,
                            height:
                                MediaQuery.of(context).size.height * 0.01 * 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.menu_book_sharp,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                Text(
                                  "  $idx",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width - 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "행동 별 자세히 기록",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.itemContentList[index]
                      .map((item) => Container(
                            child:
                                // ElevatedButton(
                                //   onPressed: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             Behavior_Detail_Screen(
                                //           name: name,
                                //           behaviorName: item,
                                //         ),
                                //       ),
                                //     );
                                //   },
                                //   style: ElevatedButton.styleFrom(
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.all(Radius.circular(10))),
                                //     padding: EdgeInsets.zero,
                                //     backgroundColor:
                                //         Color.fromARGB(255, 102, 108, 255),
                                //   ),
                                //   child: Container(
                                //     width: MediaQuery.of(context).size.width *
                                //         0.025 *
                                //         8.5,
                                //     height: MediaQuery.of(context).size.height *
                                //         0.01 *
                                //         5,
                                //     child: Center(
                                //       child: Text(
                                //         '$item >',
                                //         style: const TextStyle(
                                //             color: Colors.black,
                                //             fontSize: 22,
                                //             fontWeight: FontWeight.w500),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Behavior_Detail_Screen(
                                      name: name,
                                      behaviorName: item,
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 16)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 102, 108, 255))),
                              child: Text(
                                '$item >',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ))
                      .toList(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.01 *
                        3, // Icon의 높이와 동일하게 설정
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
