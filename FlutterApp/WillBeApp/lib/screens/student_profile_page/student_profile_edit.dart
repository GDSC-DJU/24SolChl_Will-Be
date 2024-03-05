import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:solution/screens/student_profile_page/student_profile_tab_proivder.dart';

class StudentProfileEdit extends StatefulWidget {
  const StudentProfileEdit({Key? key, required this.data}) : super(key: key);
  // 아이 데이터
  final dynamic data;

  @override
  _StudentProfileEditState createState() => _StudentProfileEditState();
}

class _StudentProfileEditState extends State<StudentProfileEdit> {
  // 아이 데이터 temp
  dynamic temp = {};
  // Favorite contentList
  List<String> itemContentListFavorite = [];
  // Hate contentList
  List<String> itemContentListHate = [];
  // Medication contentList
  List<String> itemContentListMedication = [];
  // Behavior contentList
  List<String> itemContentListBehavior = [];
  // 입력값을 추적하기 위한 controller들
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
    "age": TextEditingController(),
    "favorite": TextEditingController(),
    "hate": TextEditingController(),
    "medication": TextEditingController(),
    "behavior": TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    // 초기 데이터를 할당
    temp = Map.from(widget.data);
    print(temp);
    // contentList 초기화 (리스트 형식 입력폼)
    initializeItemContentList();
  }

  void initializeItemContentList() {
    Map<String, List<String>> keyToContentList = {
      "favorite": [...temp['favorite']],
      "hate": [...temp['hate']],
      "medication": [...temp['medication']],
      "behavior": [...temp['behavior']],
    };

    setState(() {
      itemContentListFavorite = keyToContentList["favorite"] ?? [];
      itemContentListHate = keyToContentList["hate"] ?? [];
      itemContentListMedication = keyToContentList["medication"] ?? [];
      itemContentListBehavior = keyToContentList["behavior"] ?? [];
    });

    for (String dataKey in keyToContentList.keys) {
      if (temp.containsKey(dataKey) && temp[dataKey] != null) {
        List<String> contentList = [];

        if (temp[dataKey] is List<String>?) {
          contentList.addAll(temp[dataKey]!.cast<String>());
        } else if (temp[dataKey] is String) {
          contentList.add(temp[dataKey]);
        }

        textControllers[dataKey]!.text = contentList.join(", ");
        textControllers["name"]!.text = temp["name"];
        textControllers["age"]!.text = temp["age"];
      }
    }
  }

  // 생년월일 형식 변환 함수
  void updateAge() {
    int? year = temp["selectedYear"];
    int? month = temp["selectedMonth"];
    int? day = temp["selectedDay"];

    if (year != null && month != null && day != null) {
      setState(() {
        temp["age"] = '$year.$month.$day';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> classInfoList = temp['class'].split('-');
    List<String> ageList = temp["age"].split('.');
    temp["selectedYear"] = int.parse(ageList[0]);
    temp["selectedMonth"] = int.parse(ageList[1]);
    temp["selectedDay"] = int.parse(ageList[2]);

    return ChangeNotifierProvider<TabViewPageViewProvider>(
      create: (_) =>
          TabViewPageViewProvider()..started(MediaQuery.of(context).size.width),
      child: Consumer<TabViewPageViewProvider>(
        builder: (context, state, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "아이 정보 수정하기",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              actions: <Widget>[
                // 저장 버튼
                IconButton(
                  icon: const Icon(Icons.check_box),
                  color: Color.fromARGB(255, 92, 179, 101),
                  iconSize: 35,
                  tooltip: '아이 프로필 편집',
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('저장하기')));
                    print(temp);
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // 프로필
                Container(
                  height: 160.0,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 130.0,
                          height: 130.0,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 0,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                            ),
                            child: Image.network(
                              "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tab Menu Bar
                SizedBox(
                  height: 53,
                  width: MediaQuery.sizeOf(context).width - 32,
                  child: Stack(
                    children: [
                      Wrap(
                        children: [
                          _tabBar(
                            index: 0,
                            currentIndex: state.tabIndex,
                            onTap: (i) => state.tabChanged(i),
                            context: context,
                            title: ' 인적사항',
                            icons: Icons.person,
                          ),
                          _tabBar(
                            index: 1,
                            currentIndex: state.tabIndex,
                            onTap: (i) => state.tabChanged(i),
                            context: context,
                            title: ' 현행발달수준',
                            icons: Icons.bar_chart_rounded,
                          ),
                        ],
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        bottom: 0,
                        left: state.tabIndicatorPosition,
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 32) / 2,
                          height: 3,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 32,
                  height: 12,
                ),
                // Tab Contents
                Expanded(
                  child: PageView(
                    controller: state.pageController,
                    onPageChanged: (i) => state.tabChanged(i),
                    children: [
                      // 인적 사항 content
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        // 반복되는 블록을 위한 ListView
                        child: ListView.builder(
                          key: const PageStorageKey("GRID_VIEW"),
                          itemCount: 6,
                          // 블록 builder
                          itemBuilder: (context, index) {
                            // 현재 블록에서 보여줄 리스트 (리스트 형식인 경우)
                            List<String> itemList = [];
                            switch (index) {
                              case 2:
                                itemList = itemContentListFavorite;
                                break;

                              case 3:
                                itemList = itemContentListHate;
                                break;

                              case 4:
                                itemList = itemContentListMedication;
                                break;

                              case 5:
                                itemList = itemContentListBehavior;
                                break;
                            }
                            // data 매핑을 위한 keys
                            dynamic dataKey = [
                              ["name", "이름"],
                              ["age", "생년월일"],
                              ["favorite", "좋아하는 것"],
                              ["hate", "싫어하는 것"],
                              ["medication", "복용중인 약"],
                              ["behavior", "문제행동"]
                            ];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // name Input
                                if (index == 0)
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                      // style: TextStyle(height: 3),
                                      // cursorHeight: 30,
                                      style:
                                          TextStyle(height: 1.5, fontSize: 20),
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        floatingLabelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 108, 255),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        labelText: '이름',
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(
                                            top: -20, bottom: 4),
                                        focusColor: Colors.blue,
                                        labelStyle: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black38,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller:
                                          textControllers[dataKey[index][0]],
                                      onChanged: (value) {
                                        setState(() {
                                          temp[dataKey[index][0]] = value;
                                        });
                                      },
                                    ),
                                  ),
                                // age Input
                                if (index == 1)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        // 년 선택
                                        Expanded(
                                          child: DropdownButtonFormField<int>(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Select Year',
                                            ),
                                            value: temp["selectedYear"] ??
                                                int.parse(ageList[0]),
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                temp["selectedYear"] = newValue;
                                                updateAge();
                                              });
                                            },
                                            items: List<int>.generate(125,
                                                    (index) => index + 1900)
                                                .toSet() // 중복 값 제거
                                                .map<DropdownMenuItem<int>>(
                                                    (int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        // 월 선택
                                        Expanded(
                                          child: DropdownButtonFormField<int>(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Select Month',
                                            ),
                                            value: temp["selectedMonth"] ??
                                                int.parse(ageList[1]),
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                temp["selectedMonth"] =
                                                    newValue;
                                                updateAge();
                                              });
                                            },
                                            items: List<int>.generate(
                                                    12, (index) => index + 1)
                                                .map<DropdownMenuItem<int>>(
                                                    (int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        // 일 선택
                                        Expanded(
                                          child: DropdownButtonFormField<int>(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Select Day',
                                            ),
                                            value: temp["selectedDay"] ??
                                                int.parse(ageList[2]),
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                temp["selectedDay"] = newValue;
                                                updateAge();
                                              });
                                            },
                                            items: List<int>.generate(
                                                    31, (index) => index + 1)
                                                .map<DropdownMenuItem<int>>(
                                                    (int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // 그 외
                                if (index > 1)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (int i = 0;
                                            i < itemList.length;
                                            i++)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  itemList[i],
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  setState(() {
                                                    itemList.removeAt(i);
                                                    temp["behavior"] =
                                                        List<String>.from(
                                                            itemList);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        if (index > 1)
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Enter ${dataKey[index][0]}',
                                                      labelStyle: TextStyle(
                                                          color: Colors.black38,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    controller: textControllers[
                                                        dataKey[index]],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: textControllers[
                                                                  dataKey[index]
                                                                      [0]]!
                                                              .text
                                                              .isEmpty ??
                                                          true
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            itemList.add(
                                                                textControllers[
                                                                        dataKey[index]
                                                                            [
                                                                            0]]!
                                                                    .text);
                                                            temp[dataKey[
                                                                index]] = List<
                                                                    String>.from(
                                                                itemList);
                                                            textControllers[
                                                                    dataKey[index]
                                                                        [0]]!
                                                                .clear();
                                                          });
                                                        },
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          key: const PageStorageKey("LIST_VIEW"),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            Map level = temp['level'];
                            List dataKey = [
                              ["의사소통", "expression"],
                              ["쓰기", "writing"],
                              ["신체 기능", "physical"],
                              ["사회성", "socialSkill"],
                              ["특기사항"],
                            ];

                            List expList = [
                              "-",
                              "불가능",
                              "AAC 필요",
                              "촉진 시 단어 단위 표현 가능",
                              "자발적 단어 단위 표현 가능",
                              "자발적 문장 단위 표현 가능",
                            ];
                            List wriList = [
                              "-",
                              "불가능",
                              "음절 단위 쓰기 가능",
                              "단어 단위 쓰기 가능",
                              "문장 단위 쓰기 가능",
                            ];
                            List psyList = [
                              "-",
                              "보행 보조 인력 필요",
                              "전동 휠체어 등의 기구 사용",
                              "보행 보조 인력 불필요",
                            ];
                            List socList = [
                              "-",
                              "말 못함",
                              "대화 불가",
                              "한 두 마디 가능",
                              "대화 가능",
                            ];

                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataKey[index][0],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (index < 4)
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                              value: (index == 0
                                                  ? expList[0]
                                                  : index == 1
                                                      ? wriList[0]
                                                      : index == 2
                                                          ? psyList[0]
                                                          : index == 3
                                                              ? socList[0]
                                                              : expList[0]),
                                              onChanged: (dynamic newValue) {
                                                setState(() {
                                                  level[dataKey[index][1]] =
                                                      newValue;
                                                });
                                              },
                                              items: index == 0
                                                  ? expList.map((value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList()
                                                  : index == 1
                                                      ? wriList.map((value) {
                                                          return DropdownMenuItem(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList()
                                                      : index == 2
                                                          ? psyList
                                                              .map((value) {
                                                              return DropdownMenuItem(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList()
                                                          : index == 3
                                                              ? socList
                                                                  .map((value) {
                                                                  return DropdownMenuItem(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value),
                                                                  );
                                                                }).toList()
                                                              : [],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (index == 4)
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  GestureDetector _tabBar({
    required BuildContext context,
    required String title,
    required int index,
    required int currentIndex,
    required Function(int) onTap,
    required IconData icons,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        color: Colors.transparent,
        width: (MediaQuery.of(context).size.width - 32) / 2,
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons,
              size: 30,
              color: currentIndex == index
                  ? Colors.black
                  : const Color.fromRGBO(215, 215, 215, 1),
            ),
            Text(
              title,
              style: TextStyle(
                color: currentIndex == index
                    ? Colors.black
                    : const Color.fromRGBO(215, 215, 215, 1),
                fontWeight: FontWeight.bold,
                fontSize: currentIndex == index ? 20 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
