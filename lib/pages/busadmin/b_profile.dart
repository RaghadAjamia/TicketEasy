import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketeasy/components/appBar.dart';
import 'package:ticketeasy/components/b_BNB.dart';
import 'package:ticketeasy/theme/colors.dart';

class BProfilePage extends StatefulWidget {
  const BProfilePage({Key? key}) : super(key: key);

  @override
  _BProfilePageState createState() => _BProfilePageState();
}

class _BProfilePageState extends State<BProfilePage> {
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userNameFromPrefs = prefs.getString('userName');
    setState(() {
      userName = userNameFromPrefs ?? 'User Name';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "Profile"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Hi, $userName",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF59597C)),
              ),
              Text(
                "You can view your data here",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF59597C)),
              ),
              SizedBox(height: 30),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 0.1),
                painter: LinePainter(),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 203, 201, 201)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        color: orangee,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Name",
                            style: TextStyle(
                              color: Color(0xFF59597C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            userName,
                            style: TextStyle(
                                color: Color(0xFF222222).withOpacity(0.8),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 24),
                    ListTile(
                      leading: Icon(
                        Icons.verified_user,
                        color: orangee,
                        size: 24,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ID number",
                            style: TextStyle(
                              color: Color(0xFF59597C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "7896542", // Replace with the actual ID if needed
                            style: TextStyle(
                                color: Color(0xFF222222).withOpacity(0.8),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              SizedBox(height: 30),
              MaterialButton(
                onPressed: () async {
                  try {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('userID');
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  } catch (e) {
                    print("Error signing out: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Failed to sign out. Please try again later.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFE9B4B),
                        Color(0xFFF47814),
                      ],
                      center: Alignment.bottomCenter,
                      radius: 2.78,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 218, 146, 38).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 203, 201, 201)
      ..strokeWidth = 1;
    final start = Offset(0, 0);
    final end = Offset(size.width, 0);
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
