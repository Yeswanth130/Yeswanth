import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:whether/helpers.dart';

class CallSection extends StatelessWidget {
  const CallSection({super.key, required this.callLog});
  final CallLogEntry callLog;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey[200]!),
          top: BorderSide(width: 1, color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' ${callLog.number}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(children: [
                Icon(
                  Icons.sim_card_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  callLog.simDisplayName!.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(
            width: 80,
          ),
          IconButton(
            onPressed: () {
              callNumber(callLog.number.toString());
            },
            icon: CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Icon(
                Icons.call,
                color: Colors.green[500],
              ),
            ),
          )
        ],
      ),
    );
  }
}