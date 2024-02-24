import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution/login_screens/role_selection_screen.dart';
import 'package:solution/main_feat_screens/main_page.dart';
import 'package:solution/create_student/create_student_msg.dart';

class PrimaryLoginScreen extends StatefulWidget {
  const PrimaryLoginScreen({super.key});

  @override
  State<PrimaryLoginScreen> createState() => _PrimaryLoginScreenState();
}

class _PrimaryLoginScreenState extends State<PrimaryLoginScreen> {
  ///Instance for firebase auth
  final _authentication = FirebaseAuth.instance;

  ///파이어스토어 인스턴스 받아오기
  ///User instance for logged in user
  User? _user;

  ///구글로그인을 담당하는 메서드.
  ///또한 firestore에 로그인한 사용자의 계정이 있는지 확인하고 계정이 있다면 MainPage로 이동
  void _handleGoogleSignIn() async {
    {
      //로그인에 관련된 Auth관련 인스턴스들.
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _authentication.signInWithProvider(googleAuthProvider);

      //firestore에 관련된 인스턴스들
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      bool signedUpUser = false;
      _user = _authentication.currentUser;
      String uid = _user!.uid;

      // currentUser가 있는지 확인
      if (_user != null) {
        final docSnapshot =
            await firestore.collection('Educator').doc(_user!.uid).get();
        //파이어베이스에 등록이 되어있는지 확인
        if (docSnapshot.exists) {
          print("최근유저 확인, 파이어스토어 확인 완료.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Main_Page(),
            ),
          );
        } else {
          print("최근유저 확인, 파이어스토어 확인 실패");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Create_student_Msg(),
            ),
          );
        }
      } else {
        // 사용자의 UID가 존재하지 않으면 회원가입 페이지로 이동합니다.
        print('사용자의 UID가 존재하지 않아 회원가입 페이지로 이동합니다.');
        print('사용자의 UID : $uid');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Create_student_Msg(),
          ),
        );
      }
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
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(
        top: MediaQuery.sizeOf(context).height / 3,
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/appicon/willbe-icon-darker.png',
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 0,
                ),
                Text("Will Be",
                    style: Theme.of(context).textTheme.headlineLarge)
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
          ),
          Center(
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.4,
              child: OutlinedButton(
                onPressed: _handleGoogleSignIn,
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 22, 72, 99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/icons/google.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      child: const Text(
                        "Log in with Google",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
