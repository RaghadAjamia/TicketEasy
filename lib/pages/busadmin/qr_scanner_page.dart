import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:just_audio/just_audio.dart'; // Import just_audio package

class QRScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: QRScanner(),
    );
  }
}

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Create an AudioPlayer instance

  @override
  void dispose() {
    controller?.dispose();
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ScanCounter')
                    .doc(
                        'rOD8V42EaQw4ewqLrLB6') // Replace with your document ID
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  var data = snapshot.data!.data();
                  if (data == null) {
                    return Text('Scanned Tickets Count: 0');
                  }
                  int count = (data as Map<String, dynamic>)['count'] ?? 0;
                  return Text('Scanned Tickets Count: $count');
                },
              ),
              Center(
                child: (result != null)
                    ? Text('Scan successful: ${result!.code}')
                    : Text('Scan a code'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera(); // Pause the camera as soon as a code is scanned
      setState(() {
        result = scanData;
      });

      if (result != null) {
        String scannedCode = result!.code!;
        await _playBeepSound(); // Play the beep sound
        await _handleScannedTicket(scannedCode);
        await Future.delayed(Duration(milliseconds: 500));
        controller
            .resumeCamera(); // Resume the camera after processing is complete

        // Remove the message from the screen
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      }
    });
  }

  Future<void> _playBeepSound() async {
    await _audioPlayer.setAsset('images/scannerSoundd.mp3');
    await _audioPlayer.play();
  }

  Future<void> _handleScannedTicket(String qrCodeData) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Tickets_Info')
        .where('qrCodeData', isEqualTo: qrCodeData)
        .get();

    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid ticket.')),
      );
      return;
    }

    for (var doc in querySnapshot.docs) {
      if (doc['scanned'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket has already been scanned.')),
        );
        return;
      } else {
        await doc.reference.update({'scanned': true});
      }
    }

    await _incrementScannedCount();

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket scanned successfully!')),
    );
  }

  Future<void> _incrementScannedCount() async {
    DocumentReference counterDoc = FirebaseFirestore.instance
        .collection('ScanCounter')
        .doc('rOD8V42EaQw4ewqLrLB6'); // Replace with your actual document ID

    try {
      await counterDoc.update({'count': FieldValue.increment(1)});
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        await counterDoc.set({'count': 1});
      } else {
        rethrow;
      }
    }
  }
}
