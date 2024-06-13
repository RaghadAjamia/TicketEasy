import 'package:flutter/material.dart';
import 'package:ticketeasy/theme/colors.dart';

class logbutton extends StatelessWidget {
  final Function()? onTap;
  final String text; // New parameter for the text
  const logbutton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: bluee.withOpacity(0.3),
              blurRadius: 25,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text, // Using the text parameter
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
