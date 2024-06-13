import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80),

            const SizedBox(height: 50), // Adjust the space above the image
            Image.asset(
              'images/tour1.png',
              fit: BoxFit.contain,
            ),
           const Text("Welcome to TicketEasy",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
            const SizedBox(height: 27),
            const Text(
              "save your time with a stress-free\n transportation experience \ngiven by TicketEasy",
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
