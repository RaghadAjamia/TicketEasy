import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeDisplay extends StatelessWidget {
  final String qrCodeData;

  QRCodeDisplay({Key? key, required this.qrCodeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
        child: QrImageView(
          data: qrCodeData,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}