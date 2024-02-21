import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:solution/assets/pallet.dart';
import 'package:solution/dictionary_screens/expression_dictoinary.dart';
import 'package:solution/behavior_detail_screens/behavior_detail_screen.dart';
import 'package:solution/main_feat_screens/chart_builder.dart';
import 'package:solution/reports_screens/test.dart';
import 'package:solution/reports_screens/weekly_report_screen.dart';

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
  List<List<bool>> isSelectedList = [];

  List<List<bool>> isSelectedPeriod = []; // 기본값은 주별로 설정
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
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // 데이터를 기다리는 동안 보여줄 위젯
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

    for (int i = 0; i < isSelectedList.length; i++) {
      for (int l = 0; l < isSelectedList[l].length; l++) {
        print("i =$i");
        print("l = $l");
        print("${isSelectedList[i][l]}");
      }
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

    print("itemCOntentList");
    print(itemContentList);
    print("is");
    print(isSelectedList);

    List<String> add = [];

    for (int i = 0; i < isSelectedList[index].length; i++) {
      if (isSelectedList[index][0] == true) {
        add.add(itemContentListOfList[0]);
        colorList.add(chartService.getRandomColor());
      }
    }

    Widget periodToggleButton = ToggleButtons(
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      selectedColor: Colors.white,
      fillColor: Colors.redAccent,
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
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '주별',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '월별',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '년별',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ],
    );
    Future<LineChart> loadChart(List<String> behaviors) async {
      int chartPeriod = isSelectedPeriod[index].indexOf(true);
      print("행동 기리");
      print(behaviors.length);
      print("색 길이");
      print(colorList.length);

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

    print('object');
    print(add);
    chart = await loadChart(add);

    Widget toggleButton = ToggleButtons(
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      selectedColor: Colors.white,
      fillColor: Colors.redAccent,
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
            if (isSelectedList[index][i]) {}
          }
        });
        print('아이템 컨텐트 리스트의리스트 $itemContentListOfList');
        print('add : $add');
        LineChart newChart = await loadChart(add);

        setState(() {
          chart = newChart;
        });
      },
      isSelected: isSelectedList[index],
      children: <Widget>[
        for (int i = 0; i < itemContentList.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              itemContentList[i],
              style: const TextStyle(fontSize: 14.0),
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
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Image.network(
                          // 이미지 DB 구축 시 대치
                          "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                          fit: BoxFit.cover,
                        ),
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
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: chart,
              ),
              periodToggleButton, // 필요한 정보들을 추가
              toggleButton,
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "데일리 리포트",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.01 * 10,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: const Center(child: Text("리포트 슬라이드")),
              ),
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
                    itemCount: 10,
                    itemBuilder: (BuildContext ctx, int idx) {
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
                                    behaviorList:
                                        widget.itemContentList[index]),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.black12,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.025 *
                                10.5,
                            height:
                                MediaQuery.of(context).size.height * 0.01 * 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
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
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 16)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(
                                          255, 102, 108, 255))),
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
