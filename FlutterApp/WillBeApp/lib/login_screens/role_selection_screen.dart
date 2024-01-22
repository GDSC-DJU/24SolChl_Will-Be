import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solution/login_screens/submit_profile_screen.dart';
import 'package:solution/user_controller.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    User user = userController.user;

    return Scaffold(
      body: Expanded(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text(
                  user.email!.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Submit_Profile_Screen(
                        role: "Teacher",
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text(
                  "추후 추가",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Submit_Profile_Screen(
                                role: "non",
                              )));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
