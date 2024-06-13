import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ticketeasy/homee.dart';
import 'package:ticketeasy/homepage.dart';
import 'package:ticketeasy/login.dart';
import 'package:ticketeasy/pages/busadmin/b_home.dart';
import 'package:ticketeasy/pages/busadmin/qr_scanner_page.dart';
import 'package:ticketeasy/pages/manager/m_businfo.dart';
import 'package:ticketeasy/pages/manager/m_home.dart';
import 'package:ticketeasy/payment.dart';
import 'package:ticketeasy/payment_success.dart';
import 'package:ticketeasy/profile.dart';
import 'package:ticketeasy/purchase.dart';
import 'package:ticketeasy/signup.dart';
import 'package:ticketeasy/splashscreen.dart';
import 'package:ticketeasy/stripe_payment/stripe_keys.dart';
import 'package:ticketeasy/ticket_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'populate_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "ticketeasy",
    options: FirebaseOptions(
      apiKey: 'AIzaSyDFiuvSc0XoisNWMcDGHBU_FzUjnKOadII',
      appId: '1:775537320650:android:b2c5b5b8503bf052178a33',
      messagingSenderId: 'sendid',
      projectId: 'ticketeasy-6a455',
      storageBucket: 'myapp-b9yt18.appspot.com',
    ),
  );
  await populateFirestore();
  runApp(const MyApp());
  Stripe.publishableKey = ApiKeys.publishableKey;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userName = "";
  String userEmail = "";
  List<Map<String, String>> tickets = [];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('================ User is currently signed out!');
      } else {
        print('================ User is signed in!');
        _loadUserTickets(user.uid);
      }
    });
  }

  void _loadUserTickets(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Tickets_Info')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, String>> userTickets = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'qrCodeData': data['qrCodeData']?.toString() ?? '',
        'purchasingDate': data['Date']?.toString() ?? '',
      };
    }).toList();

    setState(() {
      tickets = userTickets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          shadowColor: Color(0xFFEFF8FC),
          elevation: BorderSide.strokeAlignOutside,
          centerTitle: true,
        ),
      ),
      home: AnimatedSplashScreen(
        splashTransition: SplashTransition.fadeTransition,
        splash: Center(
          child: Container(child: Image.asset('images/logo.png')),
        ),
        nextScreen: FutureBuilder<User?>(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator while checking auth state
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                return UserHome(); // User is signed in, navigate to home page
              } else {
                return homee(); // User is not signed in, navigate to tour pages
              }
            }
          },
        ),
      ),
      routes: {
        'payment': (context) => Payment(tickets: tickets),
        'purchase': (context) => Purchase(),
        'login': (context) => LoginPage(),
        'payment_success': (context) =>
            PaymentSuccess(newTickets: []), // Provide a default value
        'tickets': (context) => TicketPage(),
        'profile': (context) => ProfilePage(),
        'signup': (context) => SignUpPage(),
        'homepage': (context) => UserHome(),
        'homemanager': (context) => HomePage(),
        'homeadmin': (context) => ScanPage(),
        'QRScanner': (context) => QRScannerPage(),
      },
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = UserHome();
            break;
          case 'payment':
            var args = settings.arguments as Map<String, dynamic>;
            page = Payment(tickets: tickets);
            break;
          case 'payment_success':
            var args = settings.arguments as Map<String, dynamic>;
            var newTickets = args['newTickets'] as List<Map<String, String>>;
            page = PaymentSuccess(newTickets: newTickets);
            break;
          case 'tickets':
            page = TicketPage();
            break;
          case 'profile':
            page = ProfilePage();
            break;
          default:
            page = Purchase();
            break;
        }
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(
              opacity: anim,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        );
      },
    );
  }
}
