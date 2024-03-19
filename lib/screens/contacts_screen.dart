import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whether/widgets/contacts_item.dart';

import 'add_contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> allContacts = [];
  List<Contact> filteredAllContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllContacts();
    _searchController.addListener(filteredContacts);
  }

  Future<void> getAllContacts() async {
    final List<Contact> contacts =
    await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      allContacts = contacts;
    });
  }

  void filteredContacts() {
    final List<Contact> contacts = List.from(allContacts);
    if (_searchController.text.isNotEmpty) {
      contacts.retainWhere(
            (contact) {
          final String searchTerm = _searchController.text.toLowerCase();
          final String contactName = contact.displayName!.toLowerCase();
          return contactName.contains(searchTerm);
        },
      );

      setState(() {
        filteredAllContacts = contacts;
      });
    }
  }

  void _saveContact(Contact contact) async {
    if (await Permission.contacts.request().isGranted) {
      try {
        await ContactsService.addContact(contact);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contact saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save contact')),
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

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner), // Add the scanner icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScanner(), // Navigate to QRScanner
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                label: Text(
                  'Search',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddContactsPage(),
                  ),
                );
              },
              child: Text('Add New Contact'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: isSearching
                    ? filteredAllContacts.length
                    : allContacts.length,
                itemBuilder: (context, index) => ContactsItem(
                  currentContact: isSearching
                      ? filteredAllContacts[index]
                      : allContacts[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
