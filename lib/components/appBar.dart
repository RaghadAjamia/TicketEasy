import 'package:flutter/material.dart';
import 'package:ticketeasy/theme/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Title variable to hold the dynamic title
  const AppBarWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title, // Use the dynamic title passed from the constructor
        textAlign: TextAlign.center, // Center the text
        style: TextStyle(
          color: gray,
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      centerTitle: true, // Center the title in the app bar
      backgroundColor: Colors.white, // Set background color to white
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/logo.png',
            width: 53,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.2), // Set the height of the line
        child: Container(
          height: 0.5, // Height of the line
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 31, 91, 131)
                    .withOpacity(0.25), // Shadow color
                spreadRadius: 1, // Spread radius
                blurRadius: 3, // Blur radius
                offset: Offset(0, 2), // Shadow offset
              ),
            ],
            color: Color.fromARGB(255, 86, 89, 91), // Color of the line
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
