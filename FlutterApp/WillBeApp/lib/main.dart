import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:solution/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution/login_screens/primary_login_screen.dart';
import 'package:solution/main_page/main_page.dart';

void main() async {
  //플러터에서 파이어베이스를 사용하기 위해 매인메소드 안에서 비동기방식을 사용하기 위해 사용하는 함수
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///파이어베이스 로그인을 위한 Auth 인스턴스
  final _authentication = FirebaseAuth.instance;
  User? user;

  ///자동로그인의 실행 여부를 판별하는 변수. user.currentuser의 유무와 firestore에 user.uid 문서가 존재하는지 판별.
  ///둘 다 존재한다면 자동로그인 완료
  bool _currentUserExist = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///자동로그인 기능
  Future<void> checkAuthStatus() async {
    user = _authentication.currentUser;
    _currentUserExist = false;

    if (user != null) {
      // 이미 로그인한 사용자가 있으면 메인 화면으로 이동

      final docSnapshot = await _firestore
          .collection('Users')
          .doc('Educator')
          .collection(user!.uid)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        _currentUserExist = true;
        print('자동로그인 완료!');
      } else {
        print('_currentUserExost = false');
      }
    } else {
      // 로그인한 사용자가 없으면 로그인 화면을 보여줌
      print('자동로그인 실패');
      _currentUserExist = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuthStatus();
      print("object");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255),
            background: Colors.black),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: _currentUserExist
              ? const Main_Page()
              : const PrimaryLoginScreen()),
    );
  }
}
