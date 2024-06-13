import 'package:flutter/material.dart';
import 'package:ticketeasy/components/loginbutton.dart';
import 'package:ticketeasy/theme/colors.dart';

class BusAdminLogin extends StatefulWidget {
  const BusAdminLogin({Key? key}) : super(key: key);

  @override
  State<BusAdminLogin> createState() => _ManagerLoginState();
}

class _ManagerLoginState extends State<BusAdminLogin> {
  // sign user in method should be static or moved out of StatefulWidget
  static void signUserIn() {
    // Method implementation here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Action for the back button
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/logo.png',
              width: 70,
              height: 70,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Added to stretch widgets horizontally
          children: [
            Text(
              'Login',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF59597C)),
            ), // Centered the text
            const SizedBox(
              height: 25,
            ),
            // USER-EMPLOYEE

            // ID
            const SizedBox(
              height: 25,
            ),
            Text(
              ' ID number',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF59597C)),
            ),
            SizedBox(height: 5), // Added for spacing
            TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFD8DADC), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFD8DADC), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFD8DADC), width: 1),
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),
            // Password
            Text(
              ' Password',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF59597C)),
            ),
            SizedBox(height: 5), // Added for spacing
            TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFD8DADC), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFD8DADC), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFD8DADC), width: 1),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.visibility_off_outlined,
                    color: gray,
                  ),
                  // Close eye symbol
                  onPressed: () {
                    // Toggle visibility of password
                    // Implement your logic to toggle visibility of the password
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 50,
            ),
            // Login button
            logbutton(
              onTap: () {},
              text: "Login",
            )
          ],
        ),
      ),
    );
  }
}
