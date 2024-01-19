import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution/main_page/main_page.dart';

class PrimaryLoginScreen extends StatefulWidget {
  const PrimaryLoginScreen({super.key});

  @override
  State<PrimaryLoginScreen> createState() => _PrimaryLoginScreenState();
}

class _PrimaryLoginScreenState extends State<PrimaryLoginScreen> {
  ///Instance for firebase auth
  final _authentication = FirebaseAuth.instance;

  ///파이어스토어 레퍼런스 받아오기
  ///User instance for loged in user
  User? user;

  ///구글로그인을 담당하는 메서드.
  ///또한 firestore에 로그인한 사용자의 계정이 있는지 확인하고 계정이 있다면 MainPage로 이동
  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _authentication.signInWithProvider(googleAuthProvider);

      user = _authentication.currentUser;

      if (user != null) {
        print(
          user!.email.toString(),
        );

        //회원가입을 건너뛰고 메인 페이지로 이동한다.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Main_Page(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  ///Auto Login Function: checking if there is a current user. Navigate to Main_Page if we have current user.
  ///if we don't, guide user to login with google

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.sizeOf(context).height / 10,
      ),
      child: Column(
        children: [
          const Text(
            "GDSC Daejeon Univ\nSolution Challenge!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          Expanded(
            child: Center(
              child: OutlinedButton(
                  onPressed: _handleGoogleSignIn,
                  child: const Text("Sign in with google")),
            ),
          )
        ],
      ),
    );
  }
}
