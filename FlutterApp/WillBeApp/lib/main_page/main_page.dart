import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final authentication = FirebaseAuth.instance;
    user = authentication.currentUser;

    return Expanded(
      child: Column(
        children: [
          const Text("Main_Page"),
          Center(
            child: OutlinedButton(
              onPressed: () {
                user!.delete();
                Navigator.pop(context);
              },
              child: const Text("log out"),
            ),
          ),
        ],
      ),
    );
  }
}
