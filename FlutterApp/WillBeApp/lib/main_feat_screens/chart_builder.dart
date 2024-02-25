// chart_service.dart
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:solution/assets/pallet.dart';

class ChartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<LineChart> dayChartData(
      {required BuildContext context,
      required String studentID,
      required String behavior,

      /// 행동 기록 그래프를 열람할 날짜를 넣어준다.
      /// 예) 2022-08-01 또는
      /// 2022-08-01 00:00:00 과 같이 넣어준다.
      required DateTime date}) async {
    DateTime today = DateTime(date.year, date.month, date.day);

    DateTime tomorrow = today.add(const Duration(days: 1));
    double maxY = 0;
    print('today : $today');
    print('tomorrow : $tomorrow');

    /// 데이터를 FlSpot 리스트로 변환
    List<FlSpot> dataPoints = [];

    ///Time 0~24 첫번째 원소부터 마지막 원소까지 00시부터 24시까지의 횟수를 저장하기 위한
    ///변수
    List<int> dayTimes = [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];

    QuerySnapshot snapshot = await _firestore
        .collection('Record')
        .doc(studentID)
        .collection('Behavior')
        .doc(behavior)
        .collection('BehaviorRecord')
        .where('time', isGreaterThanOrEqualTo: today)
        .where('time', isLessThan: tomorrow)
        .get();

    for (var element in snapshot.docs) {
      String time = element.id.substring(11, 13);

      //String time to int
      int timeInt = int.parse(time);
      dayTimes[timeInt]++;
    }
    print("eightToSix : $dayTimes");

    //

    for (int i = 8; i < 19; i++) {
      dataPoints.add(FlSpot(i.toDouble(), dayTimes[i].toDouble()));
      if (maxY < dayTimes[i]) {
        maxY = dayTimes[i].toDouble();
      }
    }

    LineChartBarData lineChartBarData = LineChartBarData(
        spots: dataPoints,
        isCurved: false,
        barWidth: 2.5,
        isStrokeCapRound: true,
        color: BtnColors().btn1,
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(
          show: true,
          getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
              radius: 4,
              strokeWidth: 2,
              color: BtnColors().btn1,
              strokeColor: BtnColors().btn1),
        ));

    LineChartData lineChartData = LineChartData(
      lineBarsData: [lineChartBarData],

      // 제목, 그리드 등의 설정
      titlesData: FlTitlesData(
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value > maxY) return const Text('');
                return Text(value.toInt().toString());
              }),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt().toString()}시',
                  style: const TextStyle(fontSize: 12),
                );
              }),
        ),
      ),

      maxY: maxY + (maxY / 10),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
      ),
    );

    return LineChart(lineChartData);
  }

  ///입력받은 날을 기준으로 7일전의 데이터부터 일별로 출력.
  ///행동을 리스트형으로 보내주면 컬러 리스트와 맞춰서 출력해줌.
  Future<LineChart> weekChartData(
      {required String studentID,
      required List<String> behaviors,
      required BuildContext context,
      required List<Color> colors,
      required DateTime lastDateOfWeek}) async {
    DateTime today = Timestamp.fromDate(lastDateOfWeek).toDate();
    DateTime weekAgo = Timestamp.fromDate(
      lastDateOfWeek.subtract(const Duration(days: 6)),
    ).toDate();

    var weekDays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    double maxY = 0;
    List<String> weekDaysInKoreanUsage = [];
    List<int> daysInWeek = [];
    List<int> monthsInWeek = [];
    List<LineChartBarData> lines = [];

    List<DateTime> datesOfWeek = getDatesOfWeek(weekAgo, today);
    for (var element in datesOfWeek) {
      weekDaysInKoreanUsage.add(weekDays[element.weekday - 1]);
      daysInWeek.add(element.day);
      monthsInWeek.add(element.month);
    }
    List<int> numsOfList = [0, 0, 0, 0, 0, 0, 0];
    for (var i = 0; i < behaviors.length; i++) {
      List<FlSpot> dataPoints = [];
      var behavior = behaviors[i];
      var color = colors[i];
      QuerySnapshot snapshot = await _firestore
          .collection('Record')
          .doc(studentID)
          .collection('Behavior')
          .doc(behavior)
          .collection('BehaviorRecord')
          .where('time', isGreaterThanOrEqualTo: weekAgo)
          .where('time', isLessThan: today)
          .get();

      for (var element in snapshot.docs) {
        DateTime datetime = element.get('time').toDate();
        numsOfList[daysInWeek.indexOf(datetime.day)]++;
      }

      for (int i = 0; i < 7; i++) {
        dataPoints.add(FlSpot(i.toDouble(), numsOfList[i].toDouble()));
      }
      maxY = numsOfList.reduce(max).toDouble();

      lines.add(LineChartBarData(
        spots: dataPoints,
        isCurved: false,
        barWidth: 2.5,
        isStrokeCapRound: true,
        color: color, // 각 라인마다 다른 색을 사용
        belowBarData: BarAreaData(show: false),
        dotData: const FlDotData(show: true),
      ));
    }

    LineChartData lineChartData = LineChartData(
      lineBarsData: lines,
      titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
                interval: maxY == 0 ? 1 : (maxY / 6).ceilToDouble(),
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == (maxY + maxY / 10).ceilToDouble()) {
                    return const Text('');
                  }

                  if (value > maxY) {
                    return const Text('');
                  }

                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                }),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SizedBox(
                  height: 60,
                  child: Text(
                    "${weekDaysInKoreanUsage[value.toInt()]}\n${monthsInWeek[value.toInt()]}/${daysInWeek[value.toInt()]}",
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          )),
      minY: 0, // y축의 최소값을 0으로 설정

      maxY: (maxY + maxY / 10).ceilToDouble(),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.black, width: 1),
          left: BorderSide(color: Colors.black, width: 1),
          right: BorderSide(color: Colors.transparent),
        ),
      ),
    );

    return LineChart(lineChartData);
  }

  ///7주간 주별로 보여주는 차트.
  Future<LineChart> MonthlyChartData(
      {required String studentID,
      required List<String> behaviors,
      required List<Color> colors,
      required BuildContext context,
      required DateTime lastDateOfWeek}) async {
    if (behaviors.length != colors.length) {
      throw Exception("The length of behaviors and colors must be the same.");
    }

    DateTime today = Timestamp.fromDate(lastDateOfWeek).toDate();
    DateTime sevenWeeksAgo = Timestamp.fromDate(
      lastDateOfWeek.subtract(const Duration(days: 7 * 7)), // 7주 전
    ).toDate();

    double maxY = 0;
    List<DateTime> datesOfWeek = getDatesOfWeek(sevenWeeksAgo, today);

    List<String> weekPeriods = List.filled(7, ''); // 주간 기간을 저장할 리스트

    List<LineChartBarData> lineChartBarsData = [];

    for (var behaviorIndex = 0;
        behaviorIndex < behaviors.length;
        behaviorIndex++) {
      List<int> numsOfWeek = List.filled(7, 0); // 주간 데이터를 저장할 리스트

      for (var i = 0; i < 7; i++) {
        // 7주 동안의 데이터를 처리
        DateTime startOfWeek = datesOfWeek[i * 7];
        DateTime endOfWeek = (i < 6)
            ? datesOfWeek[i * 7 + 6]
            : DateTime.now()
                .add(const Duration(days: 1)); // 마지막 주의 경우 '내일'을 endOfWeek로 설정
        weekPeriods[i] =
            '${startOfWeek.month}/${startOfWeek.day}\n~${endOfWeek.month}/${endOfWeek.day - 1}'; // 주간 기간 설정

        QuerySnapshot snapshot = await _firestore
            .collection('Record')
            .doc(studentID)
            .collection('Behavior')
            .doc(behaviors[behaviorIndex])
            .collection('BehaviorRecord')
            .where('time', isGreaterThanOrEqualTo: startOfWeek)
            .where('time',
                isLessThan: endOfWeek) // 'time' 필드 값이 '내일'보다 작은 문서를 선택
            .get();

        numsOfWeek[i] = snapshot.docs.length; // 해당 주의 데이터 개수를 저장
      }

      print('numsOfWeek : $numsOfWeek');

      List<FlSpot> dataPoints = [];
      for (int i = 0; i < 7; i++) {
        dataPoints.add(FlSpot(i.toDouble(), numsOfWeek[i].toDouble()));
        if (numsOfWeek[i] > maxY) {
          maxY = numsOfWeek[i].toDouble();
        }
      }

      LineChartBarData lineChartBarData = LineChartBarData(
        spots: dataPoints,
        isCurved: false,
        barWidth: 2.5,
        isStrokeCapRound: true,
        color: colors[behaviorIndex],
        belowBarData: BarAreaData(show: false),
        dotData: const FlDotData(show: true),
      );

      lineChartBarsData.add(lineChartBarData);
    }

    LineChartData lineChartData = LineChartData(
      lineBarsData: lineChartBarsData,
      // 제목, 그리드 등의 설정
      titlesData: FlTitlesData(
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              interval: maxY == 0 ? 1 : (maxY / 6).ceilToDouble(),
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == (maxY + maxY / 10).ceilToDouble()) {
                  return const Text('');
                }

                if (value > maxY) {
                  return const Text('');
                }

                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              }),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return SizedBox(
                height: 60,
                child: Text(
                  ///주간 기간으로 출력
                  weekPeriods[value.toInt()],
                  style: const TextStyle(fontSize: 8),
                ),
              );
            },
          ),
        ),
      ),
      minY: 0,

      maxY: maxY,
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.black, width: 1),
          left: BorderSide(color: Colors.black, width: 1),
          right: BorderSide(color: Colors.transparent),
        ),
      ),

      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
      ),
    );

    return LineChart(lineChartData);
  }

  ///1년을 보여주는 차트
  Future<LineChart> yearChartData(
      {required String studentID,
      required List<String> behaviors,
      required List<Color> colors,
      required BuildContext context,
      required DateTime lastDateOfMonth}) async {
    if (behaviors.length != colors.length) {
      throw Exception("The length of behaviors and colors must be the same.");
    }

    DateTime today = Timestamp.fromDate(lastDateOfMonth).toDate();
    DateTime oneYearAgo = Timestamp.fromDate(
      lastDateOfMonth.subtract(const Duration(days: 365)), // 1년 전
    ).toDate();

    print('today : $today');

    double maxY = 0;

    List<String> monthLabels = List.filled(12, ''); // 월별 레이블을 저장할 리스트

    List<LineChartBarData> lineChartBarsData = [];

    for (var behaviorIndex = 0;
        behaviorIndex < behaviors.length;
        behaviorIndex++) {
      List<int> numsOfMonth = List.filled(12, 0); // 월별 데이터를 저장할 리스트

      for (var i = 0; i < 12; i++) {
        // 1년 동안의 데이터를 처리
        DateTime startOfMonth =
            DateTime(today.year - 1, today.month + i + 1, 1);
        DateTime endOfMonth = DateTime(today.year - 1, today.month + i + 2, 1);

        int labelMonth = startOfMonth.month;
        String labelYear = "";

        if (labelMonth == 1) {
          labelYear = ("${today.year.toString()}년");
        }

        monthLabels[i] = '$labelMonth월 \n$labelYear'; // 월별 레이블 설정

        QuerySnapshot snapshot = await _firestore
            .collection('Record')
            .doc(studentID)
            .collection('Behavior')
            .doc(behaviors[behaviorIndex])
            .collection('BehaviorRecord')
            .where('time', isGreaterThanOrEqualTo: startOfMonth)
            .where('time', isLessThan: endOfMonth)
            .get();

        numsOfMonth[i] = snapshot.docs.length;
        if (maxY < snapshot.docs.length) {
          maxY = snapshot.docs.length.toDouble();
        }
        // 해당 월의 데이터 개수를 저장
      }
      print('numsOfMonth : $numsOfMonth');

      List<FlSpot> dataPoints = [];
      for (int i = 0; i < 12; i++) {
        dataPoints.add(FlSpot(i.toDouble(), numsOfMonth[i].toDouble()));
      }

      LineChartBarData lineChartBarData = LineChartBarData(
        spots: dataPoints,
        isCurved: false,
        barWidth: 2.5,
        isStrokeCapRound: true,
        color: colors[behaviorIndex],
        belowBarData: BarAreaData(show: false),
        dotData: const FlDotData(show: true),
      );

      lineChartBarsData.add(lineChartBarData);
    }

    LineChartData lineChartData = LineChartData(
      lineBarsData: lineChartBarsData,
      // 제목, 그리드 등의 설정
      titlesData: FlTitlesData(
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              interval: maxY == 0 ? 1 : (maxY / 6).ceilToDouble(),
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == (maxY + maxY / 10).ceilToDouble()) {
                  return const Text('');
                }

                if (value > maxY) {
                  return const Text('');
                }

                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              }),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return SizedBox(
                height: 60,
                child: Text(
                  ///월별 레이블로 출력
                  monthLabels[value.toInt()],
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ),
      ),

      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
      ),
      minY: 0,
      maxY: maxY + (maxY / 10),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.black, width: 1),
          left: BorderSide(color: Colors.black, width: 1),
          right: BorderSide(color: Colors.transparent),
        ),
      ),
    );

    return LineChart(lineChartData);
  }

  Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  List<DateTime> getDatesOfWeek(DateTime start, DateTime end) {
    List<DateTime> list = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      list.add(start.add(Duration(days: i)));
    }
    return list;
  }
}
