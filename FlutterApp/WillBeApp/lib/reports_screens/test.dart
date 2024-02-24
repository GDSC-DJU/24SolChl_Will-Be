// CollectionReference educatorCollectionRef = await FirebaseFirestore.instance
//     .collection('Educator')
//     .doc(uid)
//     .collection('Student');
import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // `Firebase.initializeApp()` 사용 위해 필요
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../reporting/api_communication.dart' show ApiCommunication;

/** 
 * 학생 ID
 * 행동명 list
 * 
 * {
 *  behavior:
 *  records : 
 *    [
 *      {
 *        "stamp" : ... ,
 *        "situation" : ... ,
 *        "action" : ... ,
 *        "etc" : ... ,
 *      }
 *    ]
 * }
 * 
 * {
	"behavior" : "떼 쓰기",
	"records" : [
		{
			"stamps" : [ "09:30", "11:20", "13:10", "13:30" ],
			"situation" : "수업 중 유튜브를 보고 싶은지 컴퓨터에 대한 집착을 보였고, 컴퓨터 사이를 가로 막을 시 가로 막은 사람을 손으로 밀치며 컴퓨터로 가려 함.",
			"action" : "계속 상대를 하려 하다보면 다른 학생과 수업을 진행할 수 없다보니 컴퓨터를 제공함. ",
			"etc" : " 가로 막은 사람을 손으로 밀치며 떨쳐냈을 시 '이겼다~ 내가 해냈어!' 라는 말을 하며 펄쩍 뛰는 행동을 보임."
		},
		{
			"stamps" : [ "09:50", "14:20", "14:50" ],
			"situation" : "체육 수업 중 옆반의 또래 친구와 붙어있으려고 하며 집착을 보임.",
			"action" : "체육 교사가 강제로 둘을 분리시키면서 떼를 쓰는 상황이 더 악화되었음.",
			"etc" : "물리력을 활용한 환경 분리를 하자 행동의 강도가 더 강해짐."
		},
		{
			"stamps" : [ "11:00" ],
			"situation" : "교실에서 학생이 좋아하는 미술 활동을 하고 있었으나, 학교 행사 진행을 위해 강당으로 이동해야 하는 상황이 벌어짐.",
			"action" : "물리력을 행사하여 데려가려 하였으나, 소리를 매우 크게 지르면서 신체적인 발악을 많이 하여 강당에 데려가지 못하고 교실에서 1시간 가량 교사와 같이 있었음.",
			"etc" : "손목이 빨개질 정도로 제압이 되었으나 그럼에도 불구하고 떼 쓰는 강도를 높이며 강당 가기를 거부하고 교실에 있으려고 하였음."
		},
		{
			"stamps" : [ "11:30", "13:10", "14:30" ],
			"situation" : "같은 반 학생이 교출 행동이 심하여 교실 문을 잠구어야 하는 상황이 있었고, 교실에 자물쇠를 걸었음.",
			"action" : "교사는 결국 자물쇠를 걸지 못한 채, 문 앞에 의자를 가져다 놓은 뒤 보조 인력이 교출 위험 학생을 관찰하게 지시하였음.",
			"etc" : "자물쇠를 걸고 싶지 않은 듯, 교사가 자물쇠를 걸기만 하면 자꾸 풀고, 걸려고 하는 교사를 방해하고, 교사와 자물쇠 사이를 밀쳐냈음."
		},
		{
			"stamps" : [ "09:20", "09:40", "11:00", "12:30", "13:50" ],
			"situation" : "같은 반 친구가 동요가 나오는 장난감을 가져옴.",
			"action" : "교사가 장난감을 가지러 가려 한 하은이를 구석에 의자 놓고 앉혀놓은 후 친구의 물건을 함부로 가져가서는 안 된다며, 혼을 내었음.  하은이는 '(이해할 수 없는 말 ) 하고 싶었는 데헤에~' 라고 큰 소리로 말하며 울었음.",
			"etc" : "장난감이 가지고 싶었는지, 친구를 밀치고 친구의 장난감을 가지고 가려고 친구와 몸싸움을 벌임. 아침부터 구름이 껴있었고, 하루 종일 비가 내렸음."
		}
	]
}
 */

final CollectionReference students =
    FirebaseFirestore.instance.collection('Student');

Future<String> getStudentID(studentName) async {
  return students
      .where('name', isEqualTo: studentName)
      .get()
      .then((QuerySnapshot querySnapshot) {
    return querySnapshot.docs.first.id; // 학생 도큐먼트의 ID 문자열 반환
  });
}

String student = getStudentID('한수빙') as String;

final CollectionReference dailyReportCollectionRef = FirebaseFirestore.instance
    .collection('Student')
    .doc(student)
    .collection('Report');

// Record / 학생ID / Report / 유저ID / Weekly / 행동명
// Record / 학생ID / Behavior / 행동명 / {참고사항}
// Record / 학생ID / Behavior / 행동명 / 행동기록 / 시간 / {특이사항 / 변인}
User? user = FirebaseAuth.instance.currentUser;
// List result = [];

Future<Map<String, dynamic>> helpFunc(
  String studentId,
  List behaviorList,
  String start,
  String end,
) async {
  List result = [];
  for (var element in behaviorList) {
    result.add({
      "behavior": element,
      "records": [{}, {}, {}, {}, {}] //5일 초기화
    });
  }
  dynamic temp = await getReports(studentId, behaviorList, start, end, result);
  print(temp[0]);
  return temp[0]; // Map<String, dynamic>
}

Future<List<dynamic>> getReports(
  String studentId,
  List behaviorList,
  String start,
  String end,
  List result,
) async {
  DateTime startDate = DateTime.parse(start);
  DateTime endDate = DateTime.parse(end);
  List data = [];
  // print(studentId);
  // print(startDate);
  // print(endDate);
  CollectionReference dailyRef = FirebaseFirestore.instance
      .collection('Record')
      .doc(studentId)
      .collection('Report')
      .doc(user!.uid)
      .collection("Daily");

  await dailyRef.get().then((dateList) async {
    List<QueryDocumentSnapshot<Object?>> temp = dateList.docs
        .where((date) =>
            startDate.microsecondsSinceEpoch <=
                DateTime.parse(date.id).microsecondsSinceEpoch &&
            endDate.microsecondsSinceEpoch >=
                DateTime.parse(date.id).microsecondsSinceEpoch)
        .toList();

    temp.forEach((element) async {
      dynamic tMap = element.data();
      for (var i = 0; i < behaviorList.length; i++) {
        if (tMap[behaviorList[i]] != null) {
          data.add(
              {"${DateTime.parse(element.id).day}": tMap[behaviorList[i]]});
          result[i]['records'][DateTime.parse(element.id).day.toInt() -
              startDate.day.toInt()] = (tMap[behaviorList[i]]);
        }
      }
    });
    // print(data); // 필드값 출력
    // print(result);
  });
  dynamic temp = await getStamp(studentId, behaviorList, start, end, result);
  print(temp);
  return temp;
}

Future<List<dynamic>> getStamp(String studentId, List behaviorList,
    String start, String end, List list) async {
  var result = list;
  DateTime startDate = DateTime.parse(start);
  DateTime endDate = DateTime.parse(end);
  var idx = 0;

  for (var behavior in behaviorList) {
    Map data = {};
    CollectionReference behaviorRef = FirebaseFirestore.instance
        .collection('Record')
        .doc(studentId)
        .collection('Behavior')
        .doc(behavior)
        .collection("BehaviorRecord");
    await behaviorRef.get().then((stampList) {
      List<QueryDocumentSnapshot<Object?>> temp = stampList.docs
          .where((date) =>
              startDate.microsecondsSinceEpoch <=
                  DateTime.parse(date.id).microsecondsSinceEpoch &&
              endDate.microsecondsSinceEpoch >=
                  DateTime.parse(date.id).microsecondsSinceEpoch)
          .toList();

      temp.forEach((element) async {
        String targetDay = '${DateTime.parse(element.id).day}';
        String targetTime =
            '${DateTime.parse(element.id).hour}:${DateTime.parse(element.id).minute}';
        if (data.containsKey(targetDay)) {
          data[targetDay]!.add(targetTime);
        } else {
          data[targetDay] = [targetTime];
        }
      });
      data.keys.toList().forEach((day) async {
        result[idx]['records'][int.parse(day) - startDate.day.toInt()]
            ['stamps'] = await data[day];
      });
      idx += 1;
    });
  }
  print(result);
  return result;
}
