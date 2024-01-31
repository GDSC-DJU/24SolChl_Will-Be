import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solution/login_screens/submit_profile_screen.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key, required this.data});
  final Object data;

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
                    "Hello",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    print(data);
                  },
                ),
                ElevatedButton(
                  child: const Text(
                    "뒤로",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
