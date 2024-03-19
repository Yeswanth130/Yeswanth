import 'package:whether/screens/contacts_screen.dart';
import 'package:whether/screens/recents_call_log_screen.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const RecentsCallLogScreen();
    if (_selectedPageIndex == 1) {
      activePage = const ContactsScreen();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_rounded), label: 'Recents'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts_rounded), label: 'Contacts'),
        ],
      ),
    );
  }
}