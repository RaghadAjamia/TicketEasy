import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketeasy/stripe_payment/payment_manager.dart';

class Payment extends StatefulWidget {
  final List<Map<String, String>> tickets;

  const Payment({Key? key, required this.tickets}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController _aliasController = TextEditingController();
  int _ticketCount = 1;
  final double ticketPrice = 1.15; // Price per ticket

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('ticketCount')) {
      _ticketCount = args['ticketCount'];
    }
  }

  void _generateQRCodesAndNavigate() async {
    try {
      // Calculate the total amount
      double totalAmount = _ticketCount * ticketPrice;
      int amountInCents =
          (totalAmount * 100).toInt(); // Convert to cents for Stripe

      // Call Stripe payment function
      await PaymentManager.makePayment(amountInCents, 'usd');

      // If payment is successful, generate QR codes and navigate
      var uuid = Uuid();
      List<Map<String, String>> newTickets = [];

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        for (int i = 0; i < _ticketCount; i++) {
          String uniqueId = uuid.v4();
          DateTime now = DateTime.now();
          String date =
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
          String time = now.toIso8601String();
          String qrData = "ID: $uniqueId\nDateTime: $date $time";

          // Add the ticket to Firestore
          await FirebaseFirestore.instance.collection('Tickets_Info').add({
            'Date': date,
            'Location': 'Amman',
            'Time': now,
            'id': uniqueId,
            'qrCodeData': qrData,
            'scanned': false,
            'userId': userId, // Store the user ID
          });

          newTickets.add({'qrCodeData': qrData, 'purchasingDate': date});
        }

        widget.tickets.addAll(newTickets);

        Navigator.of(context).pushReplacementNamed(
          'payment_success',
          arguments: {
            'tickets': widget.tickets,
            'newTickets': newTickets,
          },
        );
      }
    } catch (error) {
      // Handle payment error
      print('Payment error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment",
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Text(
                    'Amount',
                    style: TextStyle(
                      color: Color(0xFF59597C),
                      fontSize: 16,
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
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '$ticketPrice JD for each ticket',
                        hintStyle: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 4,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      onPressed: _generateQRCodesAndNavigate,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 30,
                        ),
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
                              color: Color.fromARGB(255, 218, 146, 38)
                                  .withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Pay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
