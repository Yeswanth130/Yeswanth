import 'package:call_log/call_log.dart';
import 'package:whether/helpers.dart';
import 'package:whether/widgets/detailsScreenWidgets/call_logs_list.dart';
import 'package:whether/widgets/detailsScreenWidgets/call_section.dart';
import 'package:whether/widgets/detailsScreenWidgets/header.dart';
import 'package:flutter/material.dart';

class CallLogDetailsScreen extends StatefulWidget {
  const CallLogDetailsScreen({super.key, required this.callLog});

  final CallLogEntry callLog;

  @override
  State<CallLogDetailsScreen> createState() => _CallLogDetailsScreenState();
}

class _CallLogDetailsScreenState extends State<CallLogDetailsScreen> {
  late Future<Iterable<CallLogEntry>> currentCallLogs;

  @override
  void initState() {
    super.initState();
    currentCallLogs = getCurrentCallLogs(widget.callLog);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: width < 600
          ? Column(
        children: [
          Column(
            children: [
              Header(callLog: widget.callLog),
              const SizedBox(
                height: 20,
              ),
              CallSection(callLog: widget.callLog),
            ],
          ),
          CallLogsList(currentCallLogs: currentCallLogs)
        ],
      )
          : Row(
        children: [
          Column(
            children: [
              Header(callLog: widget.callLog),
              const SizedBox(
                height: 20,
              ),
              CallSection(callLog: widget.callLog),
            ],
          ),
          CallLogsList(currentCallLogs: currentCallLogs)
        ],
      ),
    );
  }
}