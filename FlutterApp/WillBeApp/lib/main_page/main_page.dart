///이 파일은 사용자가 로그인 후 최초 보여지는 화면입니다.
///로그아웃 버튼을 클릭 시 자동로그인이 풀리며 사용자의 계정 정보는 앱에서 지워지게 됩니다.
///따라서 다시 로그인을 해야합니다.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution/login_screens/primary_login_screen.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({super.key});

  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
  ///Instance for firebase auth
  final _authentication = FirebaseAuth.instance;

  ///User instance for loged in user
  User? user;
  Future<void> signOut() async {
    try {
      await _authentication.signOut(); // Here
      _authentication.currentUser!.delete;
      print('sign out complete');
    } catch (e) {
      print('sign out failed');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authentication = FirebaseAuth.instance;
    user = authentication.currentUser;

    return Center(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Main_Page",
                  style: TextStyle(fontSize: 20),
                ),
                Center(
                  child: OutlinedButton(
                    onPressed: () async {
                      await signOut();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrimaryLoginScreen(),
                        ),
                      );
                    },
                    child: const Text("log out"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
