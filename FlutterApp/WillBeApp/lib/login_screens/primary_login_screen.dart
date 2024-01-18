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

  ///User instance for loged in user
  User? user;

  ///Function for Google login service
  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _authentication.signInWithProvider(googleAuthProvider);

      user = _authentication.currentUser;

      if (user != null) {
        print(user!.email.toString());
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  ///Auto Login: checking if there is a current user. to Main_Page if we have current user. if we don't, guide user to login with google
  void checkAuthStatus() async {
    User? user = _authentication.currentUser;

    if (user != null) {
      // 이미 로그인한 사용자가 있으면 메인 화면으로 이동
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Main_Page()));
    } else {
      // 로그인한 사용자가 없으면 로그인 화면을 보여줌
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    checkAuthStatus();
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
