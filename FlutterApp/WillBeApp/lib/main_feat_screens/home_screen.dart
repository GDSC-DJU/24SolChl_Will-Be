import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solution/calender_screens/set_routine_page.dart';
import 'package:solution/student_profile_page/student_profile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:solution/create_student/add_student_info.dart';
import 'package:solution/create_student/add_behavior.dart';
import 'package:solution/dictionary_screens/expression_dictoinary.dart';

class HomeScreen extends StatefulWidget {
  List<dynamic> studentDataList;
  List<dynamic> studentIdList;
  List<dynamic> itemContentList;

  HomeScreen(
      {super.key,
      required this.studentDataList,
      required this.studentIdList,
      required this.itemContentList});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List colorList = [
    const Color.fromRGBO(255, 171, 184, 1),
    const Color.fromRGBO(134, 214, 96, 1),
    const Color.fromRGBO(104, 167, 216, 1),
    const Color.fromRGBO(239, 206, 122, 1),
    const Color.fromRGBO(195, 162, 230, 1),
    const Color.fromRGBO(255, 179, 146, 1),
    const Color.fromRGBO(151, 206, 206, 1),
  ];
  final CarouselController _controller = CarouselController();
  int _current = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print(widget.studentDataList);
    print(widget.studentIdList);
    // getBehaviorList(widget.studentIdList);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.studentDataList.isEmpty || widget.itemContentList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02, //20
            ),
            Transform.translate(
              offset: const Offset(10.0, 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 16,
                child: Text(
                  '아이들',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  User user = FirebaseAuth.instance.currentUser!;
                  String uid = user.uid;

                  List<String> situations = [
                    "새로운 놀이 기구를 사용하려 했으나 실패하자 머리를 때림",
                    "다른 학생의 물건을 가져오려 했으나 거부되자 불만을 표현하였음",
                    "수업 중에 차례를 기다리지 못하고 불안해하는 모습을 보였음",
                    "원하는 게임을 하지 못하자 분노를 표현하였음",
                    "다른 아이와의 갈등 상황에서 울면서 머리를 때림",
                    "식사를 원치 않는 음식이 나오자 식탁에서 일어났음",
                    "휴식 시간이 끝나야 해서 울면서 머리를 때림"
                  ];

                  List<String> actions = [
                    "교사는 기홍이에게 머리를 때리지 않도록 당부하였으나 계속 머리를 때림",
                    "교사는 기홍이에게 다른 학생의 물건을 존중하라고 가르치려 시도하였음",
                    "교사는 기홍이에게 차례를 기다리는 것의 중요성을 가르쳤음",
                    "교사는 기홍이에게 게임은 모두의 차례가 돌아와야 할 수 있다고 설명하였음",
                    "교사는 기홍이에게 갈등 상황에서의 적절한 행동을 가르치려고 하였음",
                    "교사는 기홍이에게 식사 시간 중에는 자리에서 일어나지 않도록 당부하였음",
                    "교사는 기홍이에게 휴식 시간이 끝난 후에 다음 활동을 기대해보라고 가르쳤음"
                  ];

                  List<String> etcs = [
                    "머리를 때린 후에는 조용히 앉아서 책을 읽음",
                    "머리를 때린 후에는 교사에게 안기고 울음",
                    "머리를 때린 후에는 차례를 기다리며 조용히 앉아 있었음",
                    "머리를 때린 후에는 다른 아이와 함께 게임을 하였음",
                    "머리를 때린 후에는 교사에게 안기고 울음",
                    "머리를 때린 후에는 식사를 마저 먹었음",
                    "머리를 때린 후에는 조용히 앉아서 책을 읽음"
                  ];

// /Record/WHd5Wn63WWIu8BaohhAk/Report/6h1TZxsr0Pe9AyrdVREBo6afyK03/Daily
                  // 날짜 구간 생성
                  List<DateTime> dates = List<DateTime>.generate(
                      7, (i) => DateTime(2024, 1, 1).add(Duration(days: i)));

                  for (int i = 0; i < dates.length; i++) {
                    await FirebaseFirestore.instance
                        .collection('Record')
                        .doc('WHd5Wn63WWIu8BaohhAk')
                        .collection('Report')
                        .doc('6h1TZxsr0Pe9AyrdVREBo6afyK03')
                        .collection('Daily')
                        .doc(DateFormat('yyyy-MM-dd').format(dates[i]))
                        .set({
                      '머리 때리기': {
                        'situation': situations[i],
                        'action': actions[i],
                        'etc': etcs[i],
                      }
                    });
                  }
                },
                child: const Text('더미데이터 발사')),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              // height: MediaQuery.of(context).size.height / 1.46,
              height: MediaQuery.of(context).size.height / 1.39,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: CarouselSlider(
                  items: List.generate(
                    widget.studentDataList.length,
                    (index) => buildCard(widget.studentDataList[index], index),
                  ),
                  carouselController: _controller,
                  options: CarouselOptions(
                    // autoPlay: true,
                    height: MediaQuery.of(context).size.height / 1.6,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    enlargeFactor: 0.25,
                    aspectRatio: 2 / 3, // 카드 비율
                    viewportFraction: 0.8, // 카드가 보이는 정도
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.studentDataList.length; i++)
                  buildDot(i, _current),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.01 * 5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Add_Student_Info(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.zero,
                    backgroundColor: const Color.fromARGB(255, 22, 72, 99),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '아이 추가하기 ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(
                          Icons.person_add_alt_1,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Object data, int index) {
    Map<String, dynamic> studentData = (data as Map<String, dynamic>);

    String name = studentData['name'];
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 252, 252, 255),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              // BoxShadow(
              //   color: const Color.fromARGB(255, 74, 74, 74).withOpacity(0.5),
              //   spreadRadius: 2,
              //   blurRadius: 5,
              //   offset: const Offset(0, 1),
              // ),
              // BoxShadow(
              //   color: Color.fromARGB(255, 111, 113, 255).withOpacity(0.3),
              //   spreadRadius: 1,
              //   blurRadius: 10,
              //   offset: const Offset(0, 0),
              // ),
              // BoxShadow(
              //   color: Color.fromARGB(255, 111, 113, 255).withOpacity(0.3),
              //   spreadRadius: 1,
              //   blurRadius: 10,
              //   offset: const Offset(0, 0),
              // ),
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height * 0.01 * 16,
                  //   alignment: Alignment.center,
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: Color.fromARGB(255, 22, 72, 99),
                  //       gradient: LinearGradient(
                  //         begin: Alignment.topRight,
                  //         end: Alignment.bottomLeft,
                  //         stops: [0.4, 0.9, 1],
                  //         colors: [
                  //           // Color.fromARGB(255, 227, 242, 253),
                  //           Color.fromARGB(255, 42, 133, 183),
                  //           Color.fromARGB(255, 24, 105, 148),
                  //           Color.fromARGB(255, 22, 72, 99),
                  //         ],
                  //         tileMode: TileMode.mirror,
                  //       ),
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(10),
                  //           topRight: Radius.circular(10))),
                  //   height: 30,
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Transform.translate(
                    offset: const Offset(0.0, -20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.height * 0.01 * 25,
                      height: MediaQuery.of(context).size.height * 0.01 * 10.3,
                      decoration: BoxDecoration(
                          color: colorList[index],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100))),
                      child: Row(
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.height * 0.01 * 10,
                            height:
                                MediaQuery.of(context).size.height * 0.01 * 10,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 0,
                                // color: colorList[index].withOpacity(0.1),
                                color: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  // side: BorderSide(
                                  //     color:
                                  //         colorList[index].withOpacity(0.5),
                                  // width: 4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: colorList[index],
                                  size: 45,
                                )
                                // Image.network(
                                //   // 이미지 DB 구축 시 대치
                                //   "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                                //   fit: BoxFit.cover,
                                // ),
                                ),
                          ),
                          Center(
                            child: Text(
                              ' $name',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01 * 2,
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height / 4.4,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6,
                            // height: MediaQuery.of(context).size.height * 0.01 * 3,
                            // color: Colors.black,
                            child: const Text("측정중인 도전행동"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...widget.itemContentList[index]
                                    .map((item) => SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.6,
                                          child: Text(
                                            '- $item',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ))
                                    .toList(),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01 *
                                      3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            MediaQuery.of(context).size.height * 0.01 * 2),
                    child: Container(
                      height: 1,
                      color: Colors.black12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025 * 11.5,
                        height:
                            MediaQuery.of(context).size.height * 0.01 * 10.5,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.height *
                                  0.01 *
                                  6.5,
                              height: MediaQuery.of(context).size.height *
                                  0.01 *
                                  6.5,
                              child: ElevatedButton(
                                onPressed: () {
                                  DocumentReference dictRef = FirebaseFirestore
                                      .instance
                                      .collection('Student')
                                      .doc(widget.studentIdList[index])
                                      .collection('Dictionary')
                                      .doc('expression');

                                  dictRef.get().then((value) {
                                    dynamic temp = value.data();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Expression_Dictionary(
                                          name: name,
                                          id: widget.studentIdList[index],
                                          iconColor: colorList[index],
                                          dictList: temp,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: colorList[index],
                                  surfaceTintColor: Colors.white,
                                  side: BorderSide(color: colorList[index]),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  padding: const EdgeInsets.all(4),
                                  backgroundColor: Colors.white,
                                ),
                                child: Icon(
                                  Icons.book,
                                  color: colorList[index],
                                  size: 25,
                                ),
                              ),
                            ),
                            const SizedBox(
                              // width: 80,
                              height: 30,
                              child: Center(
                                child: Text(
                                  '의사소통사전',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025 * 11.5,
                        height:
                            MediaQuery.of(context).size.height * 0.01 * 10.5,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.height *
                                  0.01 *
                                  6.5,
                              height: MediaQuery.of(context).size.height *
                                  0.01 *
                                  6.5,
                              child: ElevatedButton(
                                onPressed: () {
                                  DocumentReference dictRef = FirebaseFirestore
                                      .instance
                                      .collection('Student')
                                      .doc(widget.studentIdList[index])
                                      .collection('Dictionary')
                                      .doc('expression');

                                  dictRef.get().then((value) {
                                    dynamic temp = value.data();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Expression_Dictionary(
                                          name: name,
                                          id: widget.studentIdList[index],
                                          iconColor: colorList[index],
                                          dictList: temp,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: colorList[index],
                                  surfaceTintColor: Colors.white,
                                  side: BorderSide(color: colorList[index]),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  padding: const EdgeInsets.all(4),
                                  backgroundColor: Colors.white,
                                ),
                                child: Icon(
                                  Icons.settings_backup_restore_rounded,
                                  color: colorList[index],
                                  size: 25,
                                ),
                              ),
                            ),
                            const SizedBox(
                              // width: 80,
                              height: 30,
                              child: Center(
                                child: Text(
                                  '과거기록보기',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.025 * 18,
                          height: MediaQuery.of(context).size.height * 0.01 * 4,
                          child: ElevatedButton(
                            onPressed: () {
                              // 학생 ID : widget.studentIdList[index]
                              // 학생 이름 : name
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Add_Behavior(
                                    name: name,
                                    id: widget.studentIdList[index],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: colorList[index],
                              surfaceTintColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              padding: EdgeInsets.zero,
                              backgroundColor: colorList[index],
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  '도전행동 추가하기 +',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDot(int index, int currentIndex) {
    return GestureDetector(
      onTap: () => _controller.animateToPage(index),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.01 * 1.2,
        height: MediaQuery.of(context).size.height * 0.01 * 1.2,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color.fromARGB(255, 22, 72, 99))
              .withOpacity(currentIndex == index ? 0.9 : 0.4),
        ),
      ),
    );
  }
}
// 10px MediaQuery.of(context).size.height * 0.01
// 10px MediaQuery.of(context).size.width * 0.025
