import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

import 'add_contact.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: QRScanner(),
    );
  }
}

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  ScanResult? _scanResult;

  Future<void> _scanQRCode() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      setState(() {
        _scanResult = result;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddContactsPage(scanResult: _scanResult),
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          _scanResult = ScanResult(
            type: ResultType.Error,
            rawContent: 'Camera permission denied',
          );
        });
      } else {
        setState(() {
          _scanResult = ScanResult(
            type: ResultType.Error,
            rawContent: 'Unknown error: $e',
          );
        });
      }
    } on FormatException {
      setState(() {
        _scanResult = ScanResult(
          type: ResultType.Cancelled,
          rawContent: 'User returned without scanning',
        );
      });
    } catch (e) {
      setState(() {
        _scanResult = ScanResult(
          type: ResultType.Error,
          rawContent: 'Unknown error: $e',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan Result:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _scanResult != null
                  ? _scanResult!.rawContent
                  : 'No scan result',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanQRCode,
              child: Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}

