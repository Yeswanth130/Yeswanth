import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import 'contacts_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Contacts Example',
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
              _scanResult != null ? _scanResult!.rawContent : 'No scan result',
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

class AddContactsPage extends StatefulWidget {
  final ScanResult? scanResult;

  AddContactsPage({Key? key, this.scanResult}) : super(key: key);

  @override
  _AddContactsPageState createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gmailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.scanResult != null) {
      String rawData = widget.scanResult!.rawContent;
      List<String> parts = rawData.split(' ');
      if (parts.length >= 3) {
        _nameController.text = parts[0];
        _gmailController.text = parts[1];
        _phoneNumberController.text = parts.sublist(2).join(' ');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _gmailController,
              decoration: InputDecoration(labelText: 'Gmail'),
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _saveContact(context),
              child: Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveContact(BuildContext context) async {
    String name = _nameController.text.trim();
    String gmail = _gmailController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    if (await Permission.contacts.request().isGranted) {
      try {
        Contact newContact = Contact(
          givenName: name,
          phones: [Item(label: 'mobile', value: phoneNumber)],
          emails: [Item(label: 'work', value: gmail)],
        );
        await ContactsService.addContact(newContact);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Success'),
            content: Text('Contact saved successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactsScreen(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        _nameController.clear();
        _gmailController.clear();
        _phoneNumberController.clear();
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save contact. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Permission Required'),
          content: Text('Please grant permission to access contacts.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
