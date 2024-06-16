import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketeasy/main.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            const SizedBox(height: 50), // Adjust the space above the image
            Image.asset(
              'images/tour2.png',
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "Buy Tickets Anytime, Anywhere",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 27),
            const Text(
              "Buy your tickets Easily!\nJust a few taps  ",
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
