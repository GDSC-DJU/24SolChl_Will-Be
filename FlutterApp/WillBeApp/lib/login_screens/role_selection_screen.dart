import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solution/login_screens/submit_profile_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text(
                    "교사",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Submit_Profile_Screen(
                          role:
                              "Educator", //교사 선택 시 필드에 Educator로 저장하기 위해 회원가입 신청 페이지로 넘겨줌.
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text(
                    "추후 추가",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  onPressed: () {
                    ///추후 추가될 버튼의 기능이 들어갈 곳
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
