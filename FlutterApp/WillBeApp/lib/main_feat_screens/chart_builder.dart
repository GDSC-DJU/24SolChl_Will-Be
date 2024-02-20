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
    DateTime today = Timestamp.fromDate(date).toDate();
    DateTime tomorrow = Timestamp.fromDate(
      date.subtract(const Duration(days: 1)),
    ).toDate();

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
        .where('time', isGreaterThanOrEqualTo: tomorrow)
        .where('time', isLessThan: today)
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

      maxY: (dayTimes.reduce(max).toDouble() +
              dayTimes.reduce(max).toDouble() / 10)
          .ceilToDouble(),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
      ),
    );

    return LineChart(lineChartData);
  }

  ///입력받은 날을 기준으로 일주일 전부터 기준날까지의
  Future<LineChart> weekChartData(
      {required String studentID,
      required String behavior,
      required BuildContext context,

      ///주를 입력해줘야 함
      required DateTime lastDateOfWeek}) async {
    DateTime today = Timestamp.fromDate(lastDateOfWeek).toDate();
    DateTime weekAgo = Timestamp.fromDate(
      lastDateOfWeek.subtract(const Duration(days: 6)),
    ).toDate();

    print('today : $today');

    /// 데이터를 FlSpot 리스트로 변환
    List<FlSpot> dataPoints = [];

    List<DateTime> datesOfWeek = getDatesOfWeek(weekAgo, today);
    var weekDays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];

    ///날짜를 리스트의 아래 레이블로 보여주기 위한 리스트.
    List<String> weekDaysInKoreanUsage = [];

    //전 7일간의 날짜를 저장 예) 22, 23, 24, 25, 26, 27, 28
    List<int> daysInWeek = [];

    ///7일간의 날짜들의 월을 저장 예) 8,8,8,9,9,9,9 = 8월 3개 9월 4개
    List<int> monthsInWeek = [];

    /// 0~7 : 월요일~일요일까지 각 요일의 저장된 횟수를 각 원소에 저장
    List<int> numsOfList = [0, 0, 0, 0, 0, 0, 0];
    for (var element in datesOfWeek) {
      weekDaysInKoreanUsage.add(weekDays[element.weekday - 1]);
      daysInWeek.add(element.day);
      monthsInWeek.add(element.month);
      //print
    }

    QuerySnapshot snapshot = await _firestore
        .collection('Record')
        .doc(studentID)
        .collection('Behavior')
        .doc(behavior)
        .collection('BehaviorRecord')
        .where('time', isGreaterThanOrEqualTo: weekAgo)
        .where('time', isLessThan: today)
        .get();

    //각 원소 0~6까지에 그날의 횟수를 저장.
    for (var element in snapshot.docs) {
      //여기에서 각 원소에 들어갈
      DateTime datetime = element.get('time').toDate();
      print('datetime : $datetime');

      numsOfList[daysInWeek.indexOf(datetime.day)]++;

      //numsOfList[datetime.weekday - 1]]++;
    }

    for (int i = 0; i < 7; i++) {
      dataPoints.add(FlSpot(i.toDouble(), numsOfList[i].toDouble()));
    }

    ///)

    LineChartBarData lineChartBarData = LineChartBarData(
      spots: dataPoints,
      isCurved: false,
      barWidth: 2.5,
      isStrokeCapRound: true,
      color: BtnColors().btn1,
      belowBarData: BarAreaData(show: false),
      dotData: const FlDotData(show: true),
    );

    LineChartData lineChartData = LineChartData(
      lineBarsData: [lineChartBarData],
      // 제목, 그리드 등의 설정
      titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                getTitlesWidget: (value, meta) {
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
                    ///월/일 로 출력
                    "${weekDaysInKoreanUsage[value.toInt()]}\n${monthsInWeek[value.toInt()]}/${daysInWeek[value.toInt()]}",
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          )),

      maxY: (numsOfList.reduce(max).toDouble() +
              numsOfList.reduce(max).toDouble() / 10)
          .ceilToDouble(),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
      ),
    );

    return LineChart(lineChartData);
  }

  ///입력받은 날을 기준으로 한달전부터 받아오기
  Future<LineChart> monthChartData(
      {required String studentID,
      required String behavior,
      required BuildContext context,
      required DateTime lastDateOfMonth}) async {
    DateTime today = Timestamp.fromDate(lastDateOfMonth).toDate();
    DateTime monthAgo = Timestamp.fromDate(
      lastDateOfMonth.subtract(const Duration(days: 29)),
    ).toDate();

    print('today : $today');

    List<FlSpot> dataPoints = [];

    List<DateTime> datesOfMonth = getDatesOfWeek(monthAgo, today);
    var weekDays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];

    List<String> weekDaysInKoreanUsage = List.filled(30, '');
    List<int> daysInMonth = List.filled(30, 0);
    List<int> monthsInMonth = List.filled(30, 0);
    List<int> numsOfList = List.filled(30, 0);

    for (var i = 0; i < 30; i++) {
      DateTime element = datesOfMonth[i];
      weekDaysInKoreanUsage[i] = weekDays[element.weekday - 1];
      daysInMonth[i] = element.day;
      monthsInMonth[i] = element.month;
    }

    QuerySnapshot snapshot = await _firestore
        .collection('Record')
        .doc(studentID)
        .collection('Behavior')
        .doc(behavior)
        .collection('BehaviorRecord')
        .where('time', isGreaterThanOrEqualTo: monthAgo)
        .where('time', isLessThan: today)
        .get();

    for (var element in snapshot.docs) {
      DateTime datetime = element.get('time').toDate();
      print('datetime : $datetime');

      numsOfList[daysInMonth.indexOf(datetime.day)]++;
    }

    for (int i = 0; i < 30; i++) {
      dataPoints.add(FlSpot(i.toDouble(), numsOfList[i].toDouble()));
    }

    ///)

    LineChartBarData lineChartBarData = LineChartBarData(
      spots: dataPoints,
      isCurved: false,
      barWidth: 2.5,
      isStrokeCapRound: true,
      color: BtnColors().btn1,
      belowBarData: BarAreaData(show: false),
      dotData: const FlDotData(show: true),
    );

    LineChartData lineChartData = LineChartData(
      lineBarsData: [lineChartBarData],
      // 제목, 그리드 등의 설정
      titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                getTitlesWidget: (value, meta) {
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
                    ///월/일 로 출력
                    "${monthsInMonth[value.toInt()]}\n${daysInMonth[value.toInt()]}",
                    style: const TextStyle(fontSize: 8),
                  ),
                );
              },
            ),
          )),

      maxY: (numsOfList.reduce(max).toDouble() +
              numsOfList.reduce(max).toDouble() / 10)
          .ceilToDouble(),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
      ),
    );

    return LineChart(lineChartData);
  }

  List<DateTime> getDatesOfWeek(DateTime start, DateTime end) {
    List<DateTime> list = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      list.add(start.add(Duration(days: i)));
    }
    return list;
  }
}
