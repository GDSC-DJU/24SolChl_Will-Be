import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
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
    Color.fromRGBO(255, 44, 75, 1),
    Color.fromRGBO(92, 182, 50, 1),
    Color.fromRGBO(60, 153, 225, 1),
    Color.fromRGBO(252, 183, 14, 1),
    Color.fromRGBO(123, 67, 183, 1),
    Color.fromRGBO(253, 151, 54, 1),
    Color.fromRGBO(45, 197, 197, 1),
  ];
  final CarouselController _controller = CarouselController();
  int _current = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("intinetet");
    print(widget.studentDataList);
    print(widget.studentIdList);
    // getBehaviorList(widget.studentIdList);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.studentDataList.isEmpty || widget.itemContentList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02, //20
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 16,
            child: Text(
              '아이들',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            height: MediaQuery.of(context).size.height / 1.5,
            child: CarouselSlider(
              items: List.generate(
                widget.studentDataList.length,
                (index) => buildCard(widget.studentDataList[index], index),
              ),
              carouselController: _controller,
              options: CarouselOptions(
                // autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.studentDataList.length; i++)
                buildDot(i, _current),
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 20),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.zero,
                  backgroundColor: Color.fromARGB(255, 102, 108, 255),
                ),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Center(
                    child: Text(
                      '아이 추가하기',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(Object data, int index) {
    Map<String, dynamic> studentData = (data as Map<String, dynamic>);

    String name = studentData['name'];
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
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
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.01 * 10,
                    height: MediaQuery.of(context).size.height * 0.01 * 10,
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
                          color: colorList[index].withOpacity(0.5),
                          size: 45,
                        )
                        // Image.network(
                        //   // 이미지 DB 구축 시 대치
                        //   "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      name,
                      style: const TextStyle(color: Colors.black, fontSize: 30),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025 * 11.5,
                        height: MediaQuery.of(context).size.height * 0.01 * 4.5,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Expression_Dictionary(
                                  name: name,
                                  id: widget.studentIdList[index],
                                  iconColor: colorList[index].withOpacity(0.5),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.book,
                                color: Colors.black,
                                size: 15,
                              ),
                              Container(
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
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025 * 11.5,
                        height: MediaQuery.of(context).size.height * 0.01 * 4.5,
                        child: ElevatedButton(
                          onPressed: () async {},
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
                                Icons.settings_backup_restore_rounded,
                                color: Colors.black,
                                size: 15,
                              ),
                              Container(
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01 * 2,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height / 4.4,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.6,
                            // height: MediaQuery.of(context).size.height * 0.01 * 3,
                            // color: Colors.black,
                            child: Text("측정중인 도전행동"),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
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
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: EdgeInsets.zero,
                              backgroundColor:
                                  Color.fromARGB(255, 102, 108, 255),
                            ),
                            child: Container(
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
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Color.fromARGB(255, 102, 108, 255))
              .withOpacity(currentIndex == index ? 0.9 : 0.4),
        ),
      ),
    );
  }
}
// 10px MediaQuery.of(context).size.height * 0.01
// 10px MediaQuery.of(context).size.width * 0.025