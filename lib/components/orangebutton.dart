import 'package:flutter/material.dart';
import 'package:ticketeasy/theme/colors.dart';

class obutton extends StatelessWidget {
  final Function()? onTap;
  final String text; // New parameter for the text
  const obutton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 25,
        width: 80,
        padding: const EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: orangee,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text, // Using the text parameter
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
