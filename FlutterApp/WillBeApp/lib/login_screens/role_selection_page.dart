import 'package:flutter/material.dart';

class name extends StatelessWidget {
  const name({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              child: const Text("data"),
            ),
          ],
        ),
      ),
    );
  }
}
