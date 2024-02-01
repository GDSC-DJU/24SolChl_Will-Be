import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution/sudent_profile_page/student_profile_tab_proivder.dart';
import 'package:provider/provider.dart';

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
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('아이 프로필 편집 이동버튼')));
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
                      child: GridView.builder(
                        key: const PageStorageKey("GRID_VIEW"),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent:
                                (MediaQuery.of(context).size.height - 330) / 2),
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
                          return Container(
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
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: temp[dataKey[index]].length,
                                        itemBuilder: (context, idx) {
                                          return Center(
                                            child: Text(
                                              temp[dataKey[index]][idx],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
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
                          return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              width: MediaQuery.of(context).size.width,
                              height: 120,
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
                                    height: 80,
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
                                          index != 4
                                              ? level[dataKey[index][1]]
                                              : temp["remark"],
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
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
