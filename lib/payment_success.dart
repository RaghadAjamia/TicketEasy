import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentSuccess extends StatelessWidget {
  final List<Map<String, String>> newTickets;

  PaymentSuccess({Key? key, required this.newTickets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              child: Lottie.network(
                'https://lottie.host/e28dea5d-6bde-4f17-821b-16f11ebdfa8e/ysp7D9ihTH.json',
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
                onLoaded: (composition) {
                  Future.delayed(Duration(seconds: 2), () {
                    showDialog(
                      context: context,
                      builder: (context) => WillPopScope(
                        onWillPop: () async {
                          return false;
                        },
                        child: AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                child: Lottie.network(
                                  'https://lottie.host/d4041a8a-f1d1-4b73-b17d-f8ebbde8dd98/XyW4ZaRZxQ.json',
                                  fit: BoxFit.contain,
                                  repeat: true,
                                  animate: true,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Payment Succeed',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(0xFF59597C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 40),
                              for (var ticket in newTickets)
                                Column(
                                  children: [
                                    QrImageView(
                                      data: ticket['qrCodeData']!,
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ElevatedButton(
                                onPressed: () {
                                  final String dateTime =
                                      DateTime.now().toString();

                                  Navigator.of(context).pushNamed(
                                    'tickets',
                                    arguments: {
                                      'tickets': newTickets,
                                      'purchasingDate': dateTime,
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: Colors.orange,
                                  elevation: 3,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24,
                                  ),
                                  shadowColor: Colors.black.withOpacity(0.2),
                                ),
                                child: Text(
                                  'Go to Tickets',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Processing Payment...',
              style: TextStyle(
                color: Color(0xFF59597C),
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
