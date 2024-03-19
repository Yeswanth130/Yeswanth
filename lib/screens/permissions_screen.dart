import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whether/helpers.dart';
import 'package:whether/screens/tabs_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  late Widget content = const Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  void checkPermission() async {
    PermissionStatus statusPhone = await Permission.phone.status;
    PermissionStatus statusContacts = await Permission.contacts.status;

    if (statusPhone.isGranted && statusContacts.isGranted) {
      _openTabsScreen();
    }
    if (statusContacts.isPermanentlyDenied || statusPhone.isPermanentlyDenied) {
      await openAppSettings();
      _closeApp();
    } else {
      if (statusContacts.isDenied) {
        // Request contacts permission
        PermissionStatus permissionStatus = await Permission.contacts.request();
        if (permissionStatus.isGranted) {
          _getCallsPermissions();
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context)
          {
            return AlertDialog(
              title: Text('Permission Required'),
              content: Text(
                  'This app requires access to your contacts to function properly.'),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                  child: Text('OK'),
                ),
              ],
            );
          },
          );
          }
      } else {
        _getCallsPermissions();
      }
    }
  }

  void _getCallsPermissions() async {
    PermissionStatus statusPhone = await Permission.phone.request();
    PermissionStatus statusContacts = await Permission.contacts.request();

    if (statusPhone.isGranted && statusContacts.isGranted) {
      _openTabsScreen();
    }
    if (statusContacts.isPermanentlyDenied || statusPhone.isPermanentlyDenied) {
      await openAppSettings();
      _closeApp();
    } else {
      setState(() {
        content = messenger(
            closeAppFunction: _closeApp, allowFunction: _getCallsPermissions);
      });
    }
  }

  void _openTabsScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const TabsScreen(),
    ));
  }

  void _closeApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content,
    );
  }
}
