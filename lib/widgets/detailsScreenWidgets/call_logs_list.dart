import 'package:call_log/call_log.dart';
import 'package:whether/widgets/detail_call_log_item.dart';
import 'package:flutter/material.dart';

class CallLogsList extends StatelessWidget {
  const CallLogsList({super.key, required this.currentCallLogs});
  final Future<Iterable<CallLogEntry>> currentCallLogs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currentCallLogs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Iterable<CallLogEntry> entries = snapshot.data!;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Call logs (${entries.isNotEmpty ? entries.length : 0})',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: entries.length,
                      itemBuilder: (context, index) => DetailCallLogItem(
                        currentCallLog: entries.elementAt(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}