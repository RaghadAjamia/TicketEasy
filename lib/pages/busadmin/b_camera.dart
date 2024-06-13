import 'package:flutter/material.dart';
import 'package:ticketeasy/components/appBar.dart';
import 'package:ticketeasy/components/b_BNB.dart';
class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _ManagerLoginState();
}

class _ManagerLoginState extends State<CameraPage> {
  // sign user in method should be static or moved out of StatefulWidget
  static void signUserIn() {
    // Method implementation here
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "Camera "),
      body: Container(
       
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
