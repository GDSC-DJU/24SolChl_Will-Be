import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:solution/screens/create_student/create_student_msg.dart';

import 'package:solution/screens/student_profile_page/student_profile_edit.dart';
import 'package:solution/screens/student_profile_page/student_profile_tab_proivder.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key, required this.data});
  final Object data;

  @override
  Widget build(BuildContext context) {
    dynamic temp = data;
    List<String> classInfoList = temp['class'].split('-');
    return ChangeNotifierProvider<TabViewPageViewProvider>(
      create: (_) =>
          TabViewPageViewProvider()..started(MediaQuery.of(context).size.width),
      child:
          Consumer<TabViewPageViewProvider>(builder: (context, state, child) {
        return Scaffold(
            appBar: AppBar(actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: '아이 프로필 편집',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentProfileEdit(
                        data: temp,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.book),
                color: Color.fromARGB(255, 92, 179, 101),
                iconSize: 35,
                tooltip: '튜토리얼',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Create_student_Msg(),
                    ),
                  );
                },
              ),
            ]),
            body: Column(
              children: [
                Container(
                  height: 160.0,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              // 이미지 DB 구축 시 대치
                              "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          // width: 150,
                          height: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                temp['school'] +
                                    ' ' +
                                    classInfoList[0] +
                                    '학년' +
                                    ' ' +
                                    classInfoList[1] +
                                    '반',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                temp['name'],
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              Text(temp['age']),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
                Expanded(
                    child: PageView(
                  controller: state.pageController,
                  onPageChanged: (i) => state.tabChanged(i),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        key: const PageStorageKey("GRID_VIEW"),
                        itemCount: 4,
                        itemBuilder: ((context, index) {
                          // color List
                          List<Color> _color = [
                            const Color.fromRGBO(255, 170, 170, 1),
                            const Color.fromRGBO(206, 216, 235, 1),
                            const Color.fromRGBO(255, 227, 201, 1),
                            const Color.fromRGBO(218, 197, 245, 1),
                          ];
                          List<Color> _iconColor = [
                            const Color.fromRGBO(255, 89, 89, 1),
                            const Color.fromRGBO(118, 143, 190, 1),
                            const Color.fromRGBO(232, 177, 127, 1),
                            const Color.fromRGBO(178, 168, 210, 1),
                          ];
                          List dataKey = [
                            "favorite",
                            "hate",
                            "medication",
                            "behavior"
                          ];
                          List iconList = [
                            Icons.favorite,
                            Icons.thunderstorm,
                            Icons.medication,
                            Icons.error
                          ];

                          // 각 아이템의 내용을 List<String>으로 변환
                          List<String> itemContentList =
                              List<String>.from(temp[dataKey[index]]);

                          // 아이템 내용을 Column으로 표현
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              elevation: 0,
                              color: _color[index],
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      iconList[index],
                                      size: 30,
                                      color: _iconColor[index],
                                    ),
                                    ...itemContentList
                                        .map((item) => Center(
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    SizedBox(
                                      height: 30, // Icon의 높이와 동일하게 설정
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        key: const PageStorageKey("LIST_VIEW"),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          // 현행 수준 Data
                          Map level = temp['level'];
                          // (title, key for level)
                          List dataKey = [
                            ["의사소통", "expression"],
                            ["쓰기", "writing"],
                            ["신체 기능", "physical"],
                            ["사회성", "socialSkill"],
                            ["특기사항"],
                          ];

                          // 항목 별 content 목록
                          List expList = [
                            "",
                            "불가능",
                            "AAC 필요",
                            "촉진 시 단어 단위 표현 가능",
                            "자발적 단어 단위 표현 가능",
                            "자발적 문장 단위 표현 가능",
                          ];
                          List wriList = [
                            "",
                            "불가능",
                            "음절 단위 쓰기 가능",
                            "단어 단위 쓰기 가능",
                            "문장 단위 쓰기 가능",
                          ];
                          List psyList = [
                            "",
                            "보행 보조 인력 필요",
                            "전동 휠체어 등의 보조기구를 이용한 제한된 이동 가능",
                            "가벼운 보행 보조기구 혹은 수동 휠체어 이용한 이동 가능",
                            "제한된 걷기 가능",
                            "스스로 걷기 가능",
                          ];

                          // 각 아이템의 내용을 저장
                          String content;

                          switch (index) {
                            case 0:
                              content = expList[level[dataKey[index][1]]];
                              break;
                            case 1:
                              content = wriList[level[dataKey[index][1]]];
                              break;
                            case 2:
                              content = psyList[level[dataKey[index][1]]];
                              break;
                            case 3:
                              content = "";
                              break;
                            case 4:
                              content = temp["remark"];
                              break;
                            default:
                              content = "";
                          }
                          // 아이템의 높이 계산
                          double itemHeight = 120; // 초기 높이 설정
                          final textPainter = TextPainter(
                            text: TextSpan(
                              text: content,
                              style: TextStyle(fontSize: 22),
                            ),
                            maxLines: 2, // 적절한 값을 설정하여 여러 줄에 걸쳐 표시 가능
                            textDirection: TextDirection.ltr,
                          );
                          textPainter.layout(
                              maxWidth: MediaQuery.of(context).size.width - 32);
                          itemHeight = textPainter.height + 100; // 적절한 여백 추가

                          // 계산된 높이로 Container를 감싸서 반환
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            width: MediaQuery.of(context).size.width,
                            height: itemHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " " + dataKey[index][0],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: itemHeight - 40, // 여백 제외한 실제 내용 높이
                                  child: Card(
                                    elevation: 0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        content,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ))
              ],
            ));
      }),
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
