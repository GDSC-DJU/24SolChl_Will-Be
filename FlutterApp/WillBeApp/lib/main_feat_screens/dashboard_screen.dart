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
              height: 20,
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
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 300,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(child: Text("그래프")),
              ),
              // 필요한 정보들을 추가
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "데일리리포트",
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(child: Text("리포트 슬라이드")),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "행동 별 자세히보기",
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    TextButton(
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
                      child: Text(
                        "의사소통사전 바로가기 >",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.itemContentList[index]
                      .map((item) => Container(
                            child: TextButton(
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
                              child: Text(
                                '$item >',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ))
                      .toList(),
                  SizedBox(
                    height: 30, // Icon의 높이와 동일하게 설정
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
