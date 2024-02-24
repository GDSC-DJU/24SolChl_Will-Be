import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:solution/assets/pallet.dart';
import 'package:solution/dictionary_screens/expression_dictoinary.dart';
import 'package:solution/behavior_detail_screens/behavior_detail_screen.dart';
import 'package:solution/main.dart';
import 'package:solution/main_feat_screens/chart_builder.dart';
import 'package:solution/reports_screens/test.dart';
import 'package:solution/reports_screens/weekly_report_screen.dart';

class DashBoardScreen extends StatefulWidget {
  List<dynamic> studentDataList;
  List<dynamic> studentIdList;
  List<dynamic> itemContentList;
  List<dynamic> weeklyReports;

  List colorList = [
    const Color.fromRGBO(255, 171, 184, 1),
    const Color.fromRGBO(134, 214, 96, 1),
    const Color.fromRGBO(104, 167, 216, 1),
    const Color.fromRGBO(239, 206, 122, 1),
    const Color.fromRGBO(195, 162, 230, 1),
    const Color.fromRGBO(255, 179, 146, 1),
    const Color.fromRGBO(151, 206, 206, 1),
  ];
  DashBoardScreen(
      {super.key,
      required this.studentDataList,
      required this.studentIdList,
      required this.itemContentList,
      required this.weeklyReports});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with AutomaticKeepAliveClientMixin {
  List<List<bool>> isSelectedList = [];
  @override
  bool get wantKeepAlive => true;

  List<List<bool>> isSelectedPeriod = []; // 기본값은 주별로 설정
  @override
  Widget build(BuildContext context) {
    return Center(
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 32,
                height: MediaQuery.sizeOf(context).height - 170,
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: widget.studentDataList.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: buildSummaryCard(
                          itemContentList: widget.itemContentList[index],
                          data: widget.studentDataList[index],
                          index: index,
                          studentId: widget.studentIdList[index],
                        ),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                    child:
                                        CircularProgressIndicator())); // 데이터를 기다리는 동안 보여줄 위젯
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error: ${snapshot.error}'); // 에러가 발생한 경우 보여줄 위젯
                          } else {
                            return snapshot.data; // 데이터가 로드된 경우 보여줄 위젯
                          }
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.studentDataList.length; i++) {
      isSelectedList.add(
          List.generate(widget.itemContentList[i].length, (index) => true));
      isSelectedPeriod.add([true, false, false]);
    }
  }

  Future<Widget> buildSummaryCard(
      {required Object data,
      required int index,
      required Object studentId,
      required Object itemContentList}) async {
    Map<String, dynamic> studentData = (data as Map<String, dynamic>);

    var itemContentListOfList = (itemContentList as List<dynamic>);
    ChartService chartService = ChartService();
    LineChart chart;
    String name = studentData['name'];

    List<Color> colorList = [];

    List<String> add = [];

    for (int i = 0; i < isSelectedList[index].length; i++) {
      if (isSelectedList[index][i] == true) {
        add.add(itemContentListOfList[i]);
        colorList.add(BtnColors().btnColorList[i]);
      }
    }

    Widget periodToggleButton = ToggleButtons(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      selectedColor: const Color.fromARGB(255, 0, 0, 0),
      fillColor: const Color.fromARGB(255, 207, 207, 207),
      color: Colors.black,
      onPressed: (int selectedIndex) {
        setState(() {
          for (int i = 0; i < isSelectedPeriod[index].length; i++) {
            if (i == selectedIndex) {
              isSelectedPeriod[index][i] = true;
            } else {
              isSelectedPeriod[index][i] = false;
            }
          }
        });
      },
      isSelected: isSelectedPeriod[index],
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8, horizontal: MediaQuery.of(context).size.width * 0.1),
          child: const Text(
            '주별',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8, horizontal: MediaQuery.of(context).size.width * 0.1),
          child: const Text(
            '월별',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8, horizontal: MediaQuery.of(context).size.width * 0.1),
          child: const Text(
            '년별',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ],
    );
    Future<LineChart> loadChart(List<String> behaviors) async {
      int chartPeriod = isSelectedPeriod[index].indexOf(true);

      switch (chartPeriod) {
        case 0:
          LineChart weekChart = await chartService.weekChartData(
              colors: colorList,
              context: context,
              lastDateOfWeek: DateTime.now(),
              studentID: studentId.toString(),
              behaviors: behaviors);
          return weekChart;
        case 1:
          LineChart monthlyChart = await chartService.MonthlyChartData(
              colors: colorList,
              context: context,
              lastDateOfWeek: DateTime.now(),
              studentID: studentId.toString(),
              behaviors: behaviors);
          return monthlyChart;

        case 2:
          LineChart yearChart = await chartService.yearChartData(
              colors: colorList,
              context: context,
              lastDateOfMonth: DateTime.now(),
              studentID: studentId.toString(),
              behaviors: behaviors);
          return yearChart;
      }
      LineChart weekChart = await chartService.weekChartData(
          colors: colorList,
          context: context,
          lastDateOfWeek: DateTime.now(),
          studentID: studentId.toString(),
          behaviors: behaviors);
      return weekChart;
    }

    chart = await loadChart(add);

    Widget toggleButton = ToggleButtons(
      selectedColor: Colors.white,
      textStyle: const TextStyle(fontSize: 12),
      borderWidth: 0,
      borderColor: Colors.white,
      color: Colors.black,
      onPressed: (int selectedIndex) async {
        setState(() {
          for (int i = 0; i < isSelectedList[index].length; i++) {
            if (i == selectedIndex) {
              isSelectedList[index][i] = !isSelectedList[index][i];
            }
          }
          add.clear();
          add = [];
          colorList.clear();
          colorList = [];
          for (int i = 0; i < isSelectedList[index].length; i++) {
            if (isSelectedList[index][i]) {
              add.add(itemContentListOfList[i]);
              colorList.add(BtnColors().btnColorList[i]);
            }
          }
        });
      },
      isSelected: isSelectedList[index],
      children: <Widget>[
        for (int i = 0; i < itemContentList.length; i++)
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Text(
              itemContentList[i],
              style: TextStyle(
                  fontSize: 20.0,
                  color: isSelectedList[index][i]
                      ? BtnColors().btnColorList[i].withOpacity(0.8)
                      : const Color.fromARGB(255, 189, 189, 189)),
            ),
          ),
      ],
    );

    return GestureDetector(
      onTap: () {
        // 탭 시 처리 로직 추가
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5),
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
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: widget.colorList[index], width: 3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Icon(
                          Icons.person,
                          color: widget.colorList[index],
                          size: 25,
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
                        name,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 30),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        DocumentReference dictRef = FirebaseFirestore.instance
                            .collection('Student')
                            .doc(widget.studentIdList[index])
                            .collection('Dictionary')
                            .doc('expression');

                        dictRef.get().then((value) {
                          dynamic temp = value.data();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Expression_Dictionary(
                                name: name,
                                id: widget.studentIdList[index],
                                iconColor: widget.colorList[index],
                                dictList: temp,
                              ),
                            ),
                          );
                        });
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
                        width: MediaQuery.of(context).size.width * 0.025 * 10.5,
                        height: MediaQuery.of(context).size.height * 0.01 * 5,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.book,
                              color: Colors.white,
                              size: 15,
                            ),
                            Text(
                              " 의사소통사전",
                              style: TextStyle(
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
                decoration: const BoxDecoration(),
                child: chart,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  periodToggleButton,
                ],
              ), // 필요한 정보들을 추가
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal, child: toggleButton),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "주간 리포트",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.01 * 10,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // DB로 받은 리포트 수
                    itemCount: widget.weeklyReports[index].length,
                    itemBuilder: (BuildContext ctx, int idx) {
                      String left =
                          widget.weeklyReports[index][idx].split('_')[0];
                      String right =
                          widget.weeklyReports[index][idx].split('_')[1];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Weekly_Report_Screen(
                                  name: name,
                                  id: widget.studentIdList[index],
                                  behaviorList: widget.itemContentList[index],
                                  iconColor: widget.colorList[index],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.zero,
                            backgroundColor:
                                const Color.fromARGB(255, 217, 222, 223),
                            shadowColor: Colors.black,
                            elevation: 2,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.025 *
                                11.5,
                            height:
                                MediaQuery.of(context).size.height * 0.01 * 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.menu_book_sharp,
                                  color: Colors.black,
                                ),
                                Text(
                                  "${left.split('-')[1]}/${left.split('-')[2]} ~ ${right.split('-')[1]}/${right.split('-')[2]}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 15,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "행동 별 자세히 기록",
                        style: TextStyle(color: Colors.black, fontSize: 22),
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
                            child: TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('Record')
                                    .doc(widget.studentIdList[index])
                                    .collection('Behavior')
                                    .doc(item)
                                    .get()
                                    .then((value) {
                                  dynamic temp = value.data();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Behavior_Detail_Screen(
                                        id: widget.studentIdList[index],
                                        name: name,
                                        behaviorName: item,
                                        iconColor: widget.colorList[index],
                                        value: temp,
                                      ),
                                    ),
                                  );
                                });
                              },
                              style: ButtonStyle(
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 16)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 22, 72, 99))),
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
