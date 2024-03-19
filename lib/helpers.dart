import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

callNumber(String number) async {
  await FlutterPhoneDirectCaller.callNumber(number);
}

Future<Iterable<CallLogEntry>> getAllCallLogs() {
  return CallLog.get();
}

Future<Iterable<CallLogEntry>> getCurrentCallLogs(CallLogEntry callLog) async {
  var now = DateTime.now();
  int to = now.millisecondsSinceEpoch;
  Iterable<CallLogEntry> entries = await CallLog.query(
    dateTo: to,
    number: callLog.number,
  );

  return entries;
}

String getTitle(CallLogEntry entry) {
  if (entry.name == null) return entry.number!;
  if (entry.name!.isEmpty) {
    return entry.number!;
  } else {
    return entry.name!;
  }
}

String getAvatorTitle(CallLogEntry entry) {
  String title =
  getTitle(entry).replaceAll("+", '').replaceAll(" ", '').substring(0, 2);
  return title;
}

Icon getCallTypeIcon(CallType callType) {
  Map<String, dynamic> iconData;
  switch (callType) {
    case CallType.outgoing:
      iconData = {"color": Colors.green, 'icon': Icons.call_made_rounded};
    case CallType.missed:
      iconData = {"color": Colors.red, 'icon': Icons.call_missed_rounded};
    case CallType.incoming:
      iconData = {"color": Colors.green, 'icon': Icons.call_received_rounded};
    case CallType.rejected:
      iconData = {
        "color": Colors.grey,
        'icon': Icons.remove_circle_outline_rounded
      };

    default:
      iconData = {"color": Colors.grey, 'icon': Icons.report_problem_rounded};
  }
  return Icon(
    iconData["icon"],
    color: iconData['color'],
    size: 14,
  );
}

String formatDate(int timeStamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  return DateFormat('MMM d  H:mm').format(date);

  // return DateFormat('d-MMM-y H:m:s').format(date);
}

String getCallLogType(CallLogEntry callLog) {
  String type = callLog.callType.toString().split('.')[1];
  String typeFinal = type[0].toUpperCase() + type.substring(1);
  return typeFinal;
}

String getCallDuration(CallLogEntry callLog) {
  int duration = callLog.duration!;
  Duration dur = Duration(seconds: duration);
  String formatedDuration = "";
  if (dur.inHours > 0) {
    formatedDuration += '${dur.inHours} h ';
  }
  if (dur.inMinutes > 0) {
    int minutes = dur.inMinutes - (dur.inHours * 60);
    formatedDuration += ' $minutes m';
  }
  if (dur.inSeconds > 0) {
    int sec = dur.inSeconds - (dur.inMinutes * 60);
    formatedDuration += ' $sec s';
  }
  if (formatedDuration.isEmpty) return "0s";
  return formatedDuration;
}

String formatDateTime(int timeStamp) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);

  return DateFormat('d/MM/y  H:mm').format(dateTime);
}

Widget messenger(
    {String msg = 'Allow "Call logs" to make and view Calls',
      required Function allowFunction,
      required Function closeAppFunction}) {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(
        left: 40,
        right: 40,
        // top: 250,
        // bottom: 250,
      ),
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Permission Denied",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    closeAppFunction();
                  },
                  child: const Text(
                    'Close App',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    allowFunction();
                  },
                  child: const Text(
                    'Allow',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}