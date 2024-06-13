import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketeasy/bottom_navigation_bar_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? displayName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          displayName = userDoc['username'];
          userEmail = user.email;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: Color(0xFF59597C),
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              displayName != null ? "Hi, $displayName" : "Loading...",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Outfit",
                color: Color(0xFF59597C),
              ),
            ),
            SizedBox(height: 7),
            Text(
              "   You can view your data here",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: "Outfit",
                color: Color(0xFF59597C),
              ),
            ),
            SizedBox(height: 27),
            CustomPaint(
              size: Size(
                MediaQuery.of(context).size.width,
                0.06,
              ),
              painter: LinePainter(),
            ),
            SizedBox(height: 38),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 223, 223, 223)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.fromLTRB(17, 17, 17, 40),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ProfileCard(
                    icon: Icons.account_circle,
                    title: "\nYour name",
                    subtitle: displayName ?? 'Loading...',
                    iconColor: Color(0xFFF47814),
                    titleColor: Color(0xFF59597C), // Set title color
                  ),
                  SizedBox(height: 20),
                  ProfileCard(
                    icon: Icons.email,
                    title: "\nYour email",
                    subtitle: userEmail ?? 'Loading...',
                    iconColor: Color(0xFFF47814), // Set icon color to orange
                    titleColor: Color(0xFF59597C), // Set title color
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            SizedBox(height: 30),
            MaterialButton(
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                await auth.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
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
                      Color(0xFFFE9B4B), // Gold color
                      Color(0xFFF47814), // Orange color
                    ],
                    center: Alignment.bottomCenter,
                    radius: 2.78,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 218, 146, 38).withOpacity(0.3),
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
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        tickets: [],
      ),
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

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color titleColor;

  const ProfileCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = Colors.black,
    this.titleColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: titleColor, // Set title color
              ),
            ),
            Text(subtitle),
          ],
        ),
      ],
    );
  }
}
