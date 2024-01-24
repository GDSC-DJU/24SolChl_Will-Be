import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution/main_page/main_page.dart';

class Submit_Profile_Screen extends StatefulWidget {
  const Submit_Profile_Screen({super.key, required this.role});

  final String role;

  @override
  State<Submit_Profile_Screen> createState() => _Submit_Profile_ScreenState();
}

class _Submit_Profile_ScreenState extends State<Submit_Profile_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  ///회원가입 메서드.
  void signUp({required String role}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Educator')
          .doc(user.uid)
          .set({
        'role': role,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Main_Page(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Center(
          child: Column(
            children: [
              Text(
                widget.role,
                style: const TextStyle(color: Colors.amber),
              ),
              ElevatedButton(
                onPressed: () {
                  signUp(role: widget.role);
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
