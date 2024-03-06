import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:provider/provider.dart';
import 'package:solution/assets/pallet.dart';
import 'package:solution/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:solution/screens/login_screens/loading_screen.dart';
import 'package:solution/screens/login_screens/primary_login_screen.dart';
import 'package:solution/screens/main_page.dart';

void main() async {
  //플러터에서 파이어베이스를 사용하기 위해 매인메소드 안에서 비동기방식을 사용하기 위해 사용하는 함수
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyModel(),
      child: const MyApp(),
    ),
  );
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
  bool currentUserExist = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///자동로그인 기능, 파이어스토어의 Educator컬렉션에 사용자의 UID로 네이밍된 문서가 있다면
  ///_currentUserExist = true로
  Future<bool> checkAuthStatus() async {
    user = _authentication.currentUser;
    if (user != null) {
      final docSnapshot =
          await _firestore.collection('Educator').doc(user!.uid).get();

      if (docSnapshot.exists) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Will-Be App의 테마 정보들.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
          background: const Color.fromARGB(255, 255, 255, 255),
          primary: const Color.fromARGB(255, 22, 72, 99),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w600),
          bodySmall: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          headlineLarge: TextStyle(
              fontSize: 60,
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w600),
        ),
      ),
      home: FutureBuilder<bool>(
        future: checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(); // 로딩 화면 위젯
          } else {
            if (snapshot.hasData && snapshot.data!) {
              return const Main_Page();
            } else {
              return const PrimaryLoginScreen();
            }
          }
        },
      ),
    );
  }
}

class MyModel with ChangeNotifier {
  BtnColors btnColors = BtnColors();

  Color get btnColor1 => btnColors.btn1;
  Color get btnColor2 => btnColors.btn2;
  Color get btnColor3 => btnColors.btn3;
  Color get btnColor4 => btnColors.btn4;
  Color get btnColor5 => btnColors.btn5;
  Color get btnColor6 => btnColors.btn6;

  void changeColor(int btnNum, Color newColor) {
    if (btnNum == 1) {
      btnColors.btn1 = newColor;
    } else if (btnNum == 2) {
      btnColors.btn2 = newColor;
    } else if (btnNum == 3) {
      btnColors.btn3 = newColor;
    } else if (btnNum == 4) {
      btnColors.btn4 = newColor;
    } else if (btnNum == 5) {
      btnColors.btn5 = newColor;
    } else if (btnNum == 6) {
      btnColors.btn6 = newColor;
    }

    notifyListeners();
  }
}
