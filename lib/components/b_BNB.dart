import 'package:flutter/material.dart';
import 'package:ticketeasy/pages/busadmin/b_home.dart';
import 'package:ticketeasy/pages/busadmin/b_profile.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _currentIndex = 0;
final List<Widget> pages = [
    ScanPage(), 
    BProfilePage(), 
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: 78,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (val) {
            setState(() {
              _currentIndex = val;
              switch (val) {
                case 0:
                  // Navigate to Home page
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ScanPage()),
                    (route) => false, 
                  );
                  break;
                case 1:
                  // Navigate to Dashboard page
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => BProfilePage()),
                    (route) => false, 
                  );
                 
                  break;
              }
            });
          },
          
          
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'Inter',
          ),
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/home.png"), size: 25),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/profile.png"), size: 25),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}