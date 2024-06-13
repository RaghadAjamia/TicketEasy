import 'package:flutter/material.dart';
import 'package:ticketeasy/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:ticketeasy/page_1.dart';
import 'package:ticketeasy/page_2.dart';
import 'package:ticketeasy/page_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class homee extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homee> {
  final _controller = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPageIndex = _controller.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: const [
                Page1(),
                Page2(),
                Page3(),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 50),
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const SlideEffect(
                  activeDotColor: Color.fromARGB(255, 214, 132, 38),
                  dotColor: Color.fromARGB(255, 180, 178, 178),
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 10,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF59597c),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_currentPageIndex == 2) {
                        // Navigate to the LoginPage if on the last page (Page 3)
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                        );
                      } else {
                        // Navigate to the next page if not on the last page
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Text(
                      _currentPageIndex < 2 ? 'Next' : 'Start',
                      style: const TextStyle(
                        color: Color(0xFF59597c),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}