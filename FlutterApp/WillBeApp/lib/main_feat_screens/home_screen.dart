import 'package:flutter/material.dart';
import 'package:solution/student_profile_page/student_profile.dart';

class HomeScreen extends StatefulWidget {
  List<dynamic> studentDataList;

  HomeScreen({super.key, required this.studentDataList});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///빌드 여기있어요~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~₩
  @override
  Widget build(BuildContext context) {
    if (widget.studentDataList.isEmpty) {
      return const CircularProgressIndicator();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: (widget.studentDataList.length / 2).ceil(),
        itemBuilder: (BuildContext context, int index) {
          return buildRowOfCards(index);
        },
      ),
    );
  }

  Widget buildRowOfCards(int rowIndex) {
    int startIndex = rowIndex * 2;
    int endIndex = (rowIndex + 1) * 2;
    endIndex = endIndex > widget.studentDataList.length
        ? widget.studentDataList.length
        : endIndex;

    List<dynamic> rowData =
        widget.studentDataList.sublist(startIndex, endIndex);

    // 데이터 수가 홀수이고 현재 행이 마지막 행인 경우
    if (rowData.length % 2 == 1 &&
        rowIndex == (widget.studentDataList.length / 2).floor()) {
      // 마지막 Card를 왼쪽 정렬
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildCard(rowData[0]),
            // 두 번째 아이템은 없으므로 비워둠
            Container(),
          ],
        ),
      );
    } else {
      // 짝수 개의 아이템인 경우나 홀수 개의 아이템인데 마지막 행이 아닌 경우
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowData.map((item) {
            return buildCard(item);
          }).toList(),
        ),
      );
    }
  }

  @override
  Widget buildCard(Object data) {
    // Object에서 필요한 필드(이름) 추출
    Map<String, dynamic> studentData = (data as Map<String, dynamic>);
    String name = studentData['name'];
    return GestureDetector(
      onTapDown: (_) {
        // 탭이 발생했을 때 해당 Card의 투명도를 낮추기
        print('onTapDown: $name');
        setState(() {
          tappedCardOpacityValue[name] = 0.3;
        });
      },
      onTapUp: (_) {
        // 탭이 해제되었을 때 해당 Card의 투명도를 초기값으로 복원
        print('onTapUp: $name');
        setState(() {
          tappedCardOpacityValue[name] = 1.0;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentProfile(
              data: studentData,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.blue.withOpacity(tappedCardOpacityValue[name] ?? 1.0),
        child: SizedBox(
          width: 150.0,
          height: 150.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Map을 사용하여 각 Card에 대한 투명도 값을 저장
  Map<String, double> tappedCardOpacityValue = {};

  double opacityValue = 1.0; // 초기 투명도 값
}
