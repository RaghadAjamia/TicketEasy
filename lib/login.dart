import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketeasy/pages/busadmin/b_home.dart';
import 'package:ticketeasy/pages/manager/m_home.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'signup.dart'; // Assuming SignUpPage is in a file named signup.dart

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CollectionReference managers =
      FirebaseFirestore.instance.collection('managers');
  CollectionReference admins = FirebaseFirestore.instance.collection('admins');

  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  bool isEmployee = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in via Firebase Authentication
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      String userType = prefs.getString('userType') ?? '';

      if (isLoggedIn) {
        if (userType == 'admin') {
          // Admin is signed in, navigate to 'homeadmin'
          Navigator.of(context)
              .pushNamedAndRemoveUntil('homeadmin', (route) => false);
        } else if (userType == 'manager') {
          // Manager is signed in, navigate to 'homemanager'
          Navigator.of(context)
              .pushNamedAndRemoveUntil('homemanager', (route) => false);
        } else {
          // Normal user is signed in, navigate to 'homepage'
          Navigator.of(context)
              .pushNamedAndRemoveUntil('homepage', (route) => false);
        }
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      // Sign out before attempting to sign in
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Save email and username to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'username': user.displayName,
        });

        // Check if the user has verified their email
        if (!user.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please verify your email first.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
      }

      // Navigate to the next screen
      Navigator.of(context)
          .pushNamedAndRemoveUntil('homepage', (route) => false);
    } catch (e) {
      setState(() {
        _emailErrorMessage = 'Google sign-in failed. Please try again.';
      });
      print('Google sign-in error: $e');
    }
  }

  Future<void> signInEmployee(String id, String password) async {
    try {
      QuerySnapshot managerSnapshot = await FirebaseFirestore.instance
          .collection('managers')
          .where('id', isEqualTo: id)
          .where('password', isEqualTo: password)
          .get();

      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .where('id', isEqualTo: id)
          .where('password', isEqualTo: password)
          .get();

      if (managerSnapshot.docs.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userID', id);
        await prefs.setString('userName',
            managerSnapshot.docs.first['id']); // Save the actual name

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (adminSnapshot.docs.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userID', id);
        await prefs.setString(
            'userName', adminSnapshot.docs.first['id']); // Save the actual name

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ScanPage()),
        );
      } else {
        setState(() {
          _emailErrorMessage = 'Invalid ID or Password';
        });
      }
    } catch (e) {
      setState(() {
        _emailErrorMessage = 'Login failed. Please check your credentials.';
      });
      print('Employee sign-in error: $e');
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Check if the user has verified their email
        if (!userCredential.user!.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please verify your email first.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        Navigator.of(context).pushReplacementNamed('homepage');
      } on FirebaseAuthException catch (e) {
        setState(() {
          switch (e.code) {
            case 'user-not-found':
              _emailErrorMessage = 'No user found for that email.';
              break;
            case 'wrong-password':
              _passwordErrorMessage = 'Wrong password provided.';
              break;
            case 'invalid-email':
              _emailErrorMessage = 'Invalid email format.';
              break;
            default:
              _emailErrorMessage =
                  'Login failed. Please check your credentials.';
              break;
          }
        });
      } catch (e) {
        setState(() {
          _emailErrorMessage = 'Login failed. Please try again.';
        });
        print('General sign-in error: $e');
      }
    }
  }

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent.'),
          duration: Duration(seconds: 2),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _emailErrorMessage =
            'Failed to send password reset email. Please try again.';
      });
      print('Password reset error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Welcome! ",
                    style: TextStyle(
                      fontSize: 28,
                      color: Color.fromARGB(255, 92, 92, 124),
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                    ),
                  ),
                  Text(
                    "Login now.",
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 92, 92, 124),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ToggleSwitch(
                changeOnTap: true,
                minWidth: 90.0,
                cornerRadius: 10.0,
                activeBgColors: [
                  [Color.fromARGB(255, 230, 123, 0)],
                  [Color.fromARGB(255, 230, 123, 0)],
                ],
                customWidths: [180.0, 180.0],
                activeFgColor: Colors.white,
                inactiveBgColor: Color(0xFFEDEEEF),
                inactiveFgColor: Color(0xFF59597C),
                initialLabelIndex: isEmployee ? 1 : 0,
                totalSwitches: 2,
                labels: ['User', 'Employee'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    isEmployee = index == 1;
                  });
                },
              ),
              SizedBox(height: 40),
              Text(
                isEmployee ? '  Employee ID' : '  Email address',
                style: TextStyle(
                  color: Color(0xFF59597C),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFFD8DADC),
                  ),
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_emailErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: Text(
                    _emailErrorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                '  Password',
                style: TextStyle(
                  color: Color(0xFF59597C),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFFD8DADC),
                  ),
                ),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                ),
              ),
              if (_passwordErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: Text(
                    _passwordErrorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: Size(50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _emailErrorMessage = null;
                    _passwordErrorMessage = null;
                  });
                  if (isEmployee) {
                    await signInEmployee(
                        emailController.text, passwordController.text);
                  } else {
                    await _signInWithEmailAndPassword();
                  }
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (!isEmployee) ...[
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    _resetPassword();
                  },
                  child: Text(
                    '   Forgot Password?',
                    style: TextStyle(
                      color: Color.fromARGB(255, 92, 92, 124),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ],
              SizedBox(height: 40),
              if (!isEmployee) ...[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 218, 218, 218),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or Login With',
                        style: TextStyle(
                          color: Color.fromARGB(255, 148, 148, 148),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 218, 218, 218),
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Image.asset(
                      'images/google.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
