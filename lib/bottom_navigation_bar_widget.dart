import 'package:flutter/material.dart';
import 'package:ticketeasy/homepage.dart';
import 'package:ticketeasy/payment.dart';
import 'package:ticketeasy/profile.dart';
import 'package:ticketeasy/purchase.dart';
import 'package:ticketeasy/ticket_page.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final List<Map<String, String>> tickets;

  const BottomNavigationBarWidget({Key? key, required this.tickets})
      : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _currentIndex = 0;

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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => UserHome()),
                    (route) => false,
                  );
                  break;
                case 1:
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Purchase()),
                    (route) => false,
                  );
                  break;
                case 2:
                  Navigator.of(context).pushNamed('tickets');
                  break;

                case 3:
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ProfilePage()),
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
          selectedIconTheme:
              IconThemeData(color: Colors.white), // Highlighted icon color
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/home.png"), size: 25),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/purchase.png"), size: 25),
              label: 'Purchase',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/ticket.png"), size: 25),
              label: 'Tickets',
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
