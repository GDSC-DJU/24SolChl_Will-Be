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
  final _authentication = FirebaseAuth.instance;
  User? user;
  bool currentUserExist = false;

  ///자동로그인 기능
  Future<void> checkAuthStatus() async {
    user = _authentication.currentUser;
    currentUserExist = false;

    if (user != null) {
      // 이미 로그인한 사용자가 있으면 메인 화면으로 이동
      currentUserExist = true;
    } else {
      // 로그인한 사용자가 없으면 로그인 화면을 보여줌
      print('자동로그인 실패');
      currentUserExist = false;
    }
    setState(() {});
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255),
            background: Colors.black),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: currentUserExist
              ? const Main_Page()
              : const PrimaryLoginScreen()),
    );
  }
}
