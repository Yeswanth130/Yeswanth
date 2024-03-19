
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
      String name = '';
      String phoneNumber = '';
      String gmail = '';

      // Regular expressions to match letters, digits, and email addresses
      RegExp letterRegex = RegExp(r'[a-zA-Z\s]');
      RegExp digitRegex = RegExp(r'(?!http)[0-9]');
      RegExp emailRegex = RegExp(
          r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'); // Email regex

      for (int i = 0; i < rawData.length; i++) {
        if (letterRegex.hasMatch(rawData[i])) {
          name += rawData[i];
        } else if (digitRegex.hasMatch(rawData[i])) {
          phoneNumber += rawData[i];
        }
      }

      // Find email address in raw content
      var match = emailRegex.firstMatch(rawData);
      if (match != null) {
        gmail = match.group(0)!;
      }

      _nameController.text = name.trim();
      _phoneNumberController.text = phoneNumber.trim();
      _gmailController.text = gmail.trim();
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
              keyboardType: TextInputType.emailAddress,
              // Add input formatters if necessary
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(?!http)[0-9]')),
              ],
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
    String phoneNumber = _phoneNumberController.text.trim();
    String gmail = _gmailController.text.trim();

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
        _phoneNumberController.clear();
        _gmailController.clear();
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
