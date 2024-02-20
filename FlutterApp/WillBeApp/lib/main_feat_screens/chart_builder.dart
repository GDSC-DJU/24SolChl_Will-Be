// chart_service.dart
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:solution/assets/pallet.dart';

class ChartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<LineChart> dayChartData(
      {required String studentID,
      required String behavior,

      /// 행동 기록 그래프를 열람할 날짜를 넣어준다.
      /// 예) 2022-08-01 또는
      /// 2022-08-01 00:00:00 과 같이 넣어준다.
      required String date}) async {
    String today = date.substring(0, 10);

    //tomrrow: 다음날의 날짜
    String tomorrow = DateTime.parse(today)
        .add(Duration(days: 1))
        .toString()
        .substring(0, 10);

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
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: today)
        .where(FieldPath.documentId, isLessThan: tomorrow)
        .get();

    for (var element in snapshot.docs) {
      String time = element.id.substring(11, 13);

      //String time to int
      int timeInt = int.parse(time);
      dayTimes[timeInt]++;
    }
    print("eightToSix : $dayTimes");

    //

    for (int i = 8; i < 18; i++) {
      dataPoints.add(FlSpot(i.toDouble(), dayTimes[i].toDouble()));
    }

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
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
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

  Future<LineChart> weekChartData(
      {required String studentID,
      required String behavior,

      ///주를 입력해줘야 함
      required String lastDateOfWeek}) async {
    String today = lastDateOfWeek.substring(0, 10);

    String tomorrow = today.substring(0, 8) +
        (int.parse(today.substring(8, 10)) + 1).toString();

    print('today : $today');
    print('tomorrow : $tomorrow');

    /// 데이터를 FlSpot 리스트로 변환
    List<FlSpot> dataPoints = [];

    ///Time 0~24 첫번째 원소부터 마지막 원소까지 00시부터 24시까지의 횟수를 저장하기 위한
    ///변수
    List<int> daysInWeek = [
      0,
      0,
      0,
      0,
      0,
      0,
    ];

    QuerySnapshot snapshot = await _firestore
        .collection('Record')
        .doc(studentID)
        .collection('Behavior')
        .doc(behavior)
        .collection('BehaviorRecord')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: today)
        .where(FieldPath.documentId, isLessThan: tomorrow)
        .get();

    for (var element in snapshot.docs) {
      String time = element.id.substring(11, 13);

      //String time to int
      int timeInt = int.parse(time);
      daysInWeek[timeInt]++;
    }
    print("eightToSix : $daysInWeek");

    //

    for (int i = 8; i < 18; i++) {
      dataPoints.add(FlSpot(i.toDouble(), daysInWeek[i].toDouble()));
    }

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
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              }),
        ),
      ),

      maxY: (daysInWeek.reduce(max).toDouble() +
              daysInWeek.reduce(max).toDouble() / 10)
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
}
