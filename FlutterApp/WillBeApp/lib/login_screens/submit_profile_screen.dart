import 'package:flutter/material.dart';

class Submit_Profile_Screen extends StatefulWidget {
  const Submit_Profile_Screen({super.key, required this.role});

  final String role;

  @override
  State<Submit_Profile_Screen> createState() => _Submit_Profile_ScreenState();
}

class _Submit_Profile_ScreenState extends State<Submit_Profile_Screen> {
  String role = "Error";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ///회원가입 메서드.
  void signUp({required role}) {
    ///현재는 role만..
    String role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Center(
          child: Column(
            children: [
              Text(
                role,
                style: const TextStyle(color: Colors.amber),
              ),
              ElevatedButton(
                onPressed: () {
                  signUp(role: role);
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
