import 'package:whether/helpers.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactsItem extends StatelessWidget {
  const ContactsItem({super.key, required this.currentContact});

  final Contact currentContact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          currentContact.displayName!.trim().substring(0, 1),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      title: Text(
        currentContact.displayName!,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        currentContact.phones!.isEmpty
            ? 'No Number'
            : currentContact.phones!.elementAt(0).value.toString(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: IconButton(
        onPressed: () {
          currentContact.phones!.isNotEmpty
              ? callNumber(currentContact.phones!.elementAt(0).value.toString())
              : ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Number is available to call'),
            ),
          );
        },
        icon: Icon(
          Icons.call,
          color: Colors.green[500],
        ),
      ),
    );
  }
}