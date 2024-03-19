import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:whether/screens/call_log_details_screen.dart';
import 'package:whether/widgets/call_log_item.dart';
import '../helpers.dart';
import 'add_contact.dart';
class RecentsCallLogScreen extends StatefulWidget {
  const RecentsCallLogScreen({super.key});

  @override
  State<RecentsCallLogScreen> createState() => _RecentsCallLogScreenState();
}

class _RecentsCallLogScreenState extends State<RecentsCallLogScreen>
    with WidgetsBindingObserver {

  late Future<Iterable<CallLogEntry>> allCallLogs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    allCallLogs = getAllCallLogs();
  }




  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        allCallLogs = getAllCallLogs();
      });
    }
  }
  void _onClickInfo(BuildContext context, CallLogEntry callLog) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CallLogDetailsScreen(callLog: callLog),
      ),
    );
  }
  void _showDialPad(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DialPad(
          onButtonPressed: (String enteredNumbers) {},
          onSaveContactPressed: (String name, String phoneNumber) {

          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recents'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder(
          future: allCallLogs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<CallLogEntry> entries = snapshot.data!.toList();

              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) => CallLogItem(
                  currentCallLog: entries.elementAt(index),
                  onClickInfo: () {
                    _onClickInfo(context, entries.elementAt(index));
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialPad(context);
        },
        child: const Icon(Icons.dialpad),
      ),
    );
  }
}

// Other classes remain the same.

class DialPad extends StatefulWidget {
  final Function(String) onButtonPressed;
  final Function(String, String) onSaveContactPressed;

  const DialPad({
    Key? key,
    required this.onButtonPressed,
    required this.onSaveContactPressed,
  }) : super(key: key);

  @override
  _DialPadState createState() => _DialPadState();
}

class _DialPadState extends State<DialPad> {
  String enteredNumbers = '';
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _onButtonPressed(String number) {
    setState(() {
      enteredNumbers += number;
    });
    widget.onButtonPressed(enteredNumbers); // Notify parent widget
  }

  void _onDeletePressed() {
    setState(() {
      if (enteredNumbers.isNotEmpty) {
        enteredNumbers = enteredNumbers.substring(0, enteredNumbers.length - 1);
      }
    });
    widget.onButtonPressed(enteredNumbers); // Notify parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'Courier',
                      ),
                      children: enteredNumbers.split('').map<TextSpan>((char) {
                        return TextSpan(text: char, style: TextStyle(letterSpacing: 0.5));
                      }).toList(),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _onDeletePressed,
                icon: Icon(Icons.backspace),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DialPadButton(number: '1', onButtonPressed: _onButtonPressed),
              DialPadButton(number: '2', onButtonPressed: _onButtonPressed),
              DialPadButton(number: '3', onButtonPressed: _onButtonPressed),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DialPadButton(number: '4', onButtonPressed: _onButtonPressed),
              DialPadButton(number: '5', onButtonPressed: _onButtonPressed),
              DialPadButton(number: '6', onButtonPressed: _onButtonPressed),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DialPadButton(number: '7', onButtonPressed: _onButtonPressed),
              DialPadButton(number: '8', onButtonPressed: _onButtonPressed),
              DialPadButton(number: '9', onButtonPressed: _onButtonPressed),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DialPadButton(number: '*', onButtonPressed: _onButtonPressed),
              DialPadButton(number: '0', onButtonPressed: _onButtonPressed),
              DialPadButton(number: '#', onButtonPressed: _onButtonPressed),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  // Implement your call logic here
                  if (enteredNumbers.isNotEmpty) {
                    // You can use the enteredNumbers to make the call
                    callNumber(enteredNumbers);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a number to call'),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.call, size: 48),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to the add contacts page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContactsPage()),
                  );
                },
                icon: Icon(Icons.person_add, size: 48),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialPadButton extends StatelessWidget {
  final String number;
  final Function(String) onButtonPressed;

  const DialPadButton({required this.number, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onButtonPressed(number),
      child: Text(number, style: TextStyle(fontSize: 20)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
      ),
    );
  }
}
